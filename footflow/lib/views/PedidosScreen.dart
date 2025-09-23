import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pedido_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/cliente.dart';
import '../models/pedido.dart';

class PedidosScreen extends StatelessWidget {
  const PedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {},
          ),
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
        body: Consumer<PedidoController>(
          builder: (context, pedidoController, child) {
            return TabBarView(
              children: [
                _OrderList(pedidos: pedidoController.pedidos, status: 'Novo'),
                _OrderList(pedidos: pedidoController.pedidos, status: 'Em Produção'),
                _OrderList(pedidos: pedidoController.pedidos, status: 'Concluído'),
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

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return OrderCard(pedido: order);
      },
    );
  }
}

// Remova a classe OrderCard e a substitua por esta
class OrderCard extends StatefulWidget {
  final Pedido pedido;

  const OrderCard({
    required this.pedido,
    super.key,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  // Lista de status possíveis
  final List<String> statusOptions = [
    'Novo',
    'Em Produção',
    'Concluído',
    'Entregue'
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Novo': return Colors.blue;
      case 'Em Produção': return Colors.orange;
      case 'Concluído': return Colors.green;
      case 'Entregue': return Colors.grey;
      default: return Colors.black;
    }
  }

  Color _getBackgroundColor(String status) {
    switch (status) {
      case 'Novo': return Colors.blue[50]!;
      case 'Em Produção': return Colors.orange[50]!;
      case 'Concluído': return Colors.green[50]!;
      case 'Entregue': return Colors.grey[300]!;
      default: return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Parte de cima do cartão (Pedido e cliente)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido #${widget.pedido.id}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Cliente: ${widget.pedido.cliente.nome}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                // Botão de 3 pontinhos
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Ação do menu de 3 pontinhos
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            
            // Parte de baixo do cartão (Data e Previsão)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Data do Pedido:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      '${widget.pedido.data.day}/${widget.pedido.data.month}/${widget.pedido.data.year}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Previsão:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      '${widget.pedido.previsao.day}/${widget.pedido.previsao.month}/${widget.pedido.previsao.year}', // Atualizado para usar a data de previsão
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // NOVO: Dropdown para o status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: _getBackgroundColor(widget.pedido.status),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.pedido.status,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  dropdownColor: Colors.white,
                  style: TextStyle(color: _getStatusColor(widget.pedido.status), fontWeight: FontWeight.bold),
                  items: statusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != widget.pedido.status) {
                      // Chama o método do controller para atualizar o status
                      Provider.of<PedidoController>(context, listen: false).atualizarStatusPedido(widget.pedido.id, newValue);
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
