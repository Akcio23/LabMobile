import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pedido_controller.dart';
import '../controllers/login_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/pedido.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    final pedidoController = Provider.of<PedidoController>(context, listen: false);
    final loginController = Provider.of<LoginController>(context, listen: false);
    try {
      await pedidoController.buscarPedidos(token: loginController.token);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao carregar pedidos: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Pedidos', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Novo'),
              Tab(text: 'Em Produção'),
              Tab(text: 'Concluído'),
            ],
          ),
        ),
        body: _isLoading ? const Center(child: CircularProgressIndicator()) :
        Consumer<PedidoController>(
          builder: (context, pedidoController, child) {
            return TabBarView(
              children: [
                _OrderList(pedidos: pedidoController.pedidos, status: 'pendente'),
                _OrderList(pedidos: pedidoController.pedidos, status: 'em_producao'),
                _OrderList(pedidos: pedidoController.pedidos, status: 'finalizado'),
              ],
            );
          },
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<Pedido> pedidos;
  final String status;
  const _OrderList({required this.pedidos, required this.status});

  @override
  Widget build(BuildContext context) {
    final filteredOrders = pedidos.where((p) => p.status == status).toList();
    if (filteredOrders.isEmpty) {
      return const Center(child: Text('Nenhum pedido encontrado.'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        final loginController = Provider.of<LoginController>(context, listen: false);
        await Provider.of<PedidoController>(context, listen: false).buscarPedidos(token: loginController.token);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return OrderCard(pedido: order);
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Pedido pedido;
  const OrderCard({required this.pedido, super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final List<String> statusOptions = ['pendente', 'em_producao', 'finalizado', 'entregue'];
  bool _isUpdating = false;

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendente': return Colors.blue;
      case 'em_producao': return Colors.orange;
      case 'finalizado': return Colors.green;
      case 'entregue': return Colors.grey;
      default: return Colors.black;
    }
  }

  Color _getBackgroundColor(String status) {
    switch (status) {
      case 'pendente': return Colors.blue[50]!;
      case 'em_producao': return Colors.orange[50]!;
      case 'finalizado': return Colors.green[50]!;
      case 'entregue': return Colors.grey[300]!;
      default: return Colors.white;
    }
  }

  Future<void> _atualizarStatus(String novoStatus) async {
    setState(() => _isUpdating = true);
    final pedidoController = Provider.of<PedidoController>(context, listen: false);
    final loginController = Provider.of<LoginController>(context, listen: false);

    final sucesso = await pedidoController.atualizarStatusPedido(widget.pedido.id, novoStatus, token: loginController.token);

    if (!mounted) return;
    setState(() => _isUpdating = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(sucesso ? 'Status atualizado para "$novoStatus"' : 'Erro ao atualizar status.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = widget.pedido.items.isNotEmpty ? widget.pedido.items[0] : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pedido #${widget.pedido.orderNumber ?? widget.pedido.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4.0),
                  Text('Cliente: ${widget.pedido.cliente?.nome ?? widget.pedido.customerId}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ]),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 16.0),
            if (firstItem != null) ...[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Item:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('${firstItem.soleName} (${firstItem.soleColor})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Qtd:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('${firstItem.totalQuantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ]),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Total:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('R\$ ${widget.pedido.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Criado:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text(widget.pedido.createdAt != null ? '${widget.pedido.createdAt!.day}/${widget.pedido.createdAt!.month}/${widget.pedido.createdAt!.year}' : '-', style: const TextStyle(fontSize: 14)),
                ]),
              ]),
              const SizedBox(height: 16),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(color: _getBackgroundColor(widget.pedido.status), borderRadius: BorderRadius.circular(12.0)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.pedido.status,
                  isExpanded: true,
                  icon: _isUpdating ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  dropdownColor: Colors.white,
                  style: TextStyle(color: _getStatusColor(widget.pedido.status), fontWeight: FontWeight.bold),
                  items: statusOptions.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != widget.pedido.status) {
                      _atualizarStatus(newValue);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
