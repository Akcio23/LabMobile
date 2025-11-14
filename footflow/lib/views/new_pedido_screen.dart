import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pedido_controller.dart';
import '../controllers/cliente_controller.dart';
import '../controllers/login_controller.dart';
import '../models/order_item.dart';
import '../models/pedido.dart';
import '../models/cliente.dart';

class NewPedidoScreen extends StatefulWidget {
  const NewPedidoScreen({super.key});

  @override
  State<NewPedidoScreen> createState() => _NewPedidoScreenState();
}

class _NewPedidoScreenState extends State<NewPedidoScreen> {
  Cliente? _selectedClient;
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();
  bool _isLoading = false;

  final Map<String, TextEditingController> _sizeControllers = {
    for (var size = 33; size <= 44; size++) size.toString(): TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    final clienteController = Provider.of<ClienteController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Novo Pedido")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButtonFormField<Cliente>(
              value: _selectedClient,
              decoration: const InputDecoration(labelText: "Cliente"),
              items: clienteController.clientes.map((cliente) {
                return DropdownMenuItem(
                  value: cliente,
                  child: Text(cliente.nome),
                );
              }).toList(),
              onChanged: (c) => setState(() => _selectedClient = c),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _itemController,
              decoration: const InputDecoration(labelText: "Nome da Sola"),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _corController,
              decoration: const InputDecoration(labelText: "Cor da Sola"),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _precoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "Preço Unitário"),
            ),
            const SizedBox(height: 24),

            const Text("Quantidades por Tamanho (33 a 44)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                mainAxisExtent: 90, 
              ),
              itemCount: _sizeControllers.length,
              itemBuilder: (context, index) {
                final size = _sizeControllers.keys.elementAt(index);
                final controller = _sizeControllers[size]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      size,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _obsController,
              decoration: const InputDecoration(labelText: "Observações"),
            ),

            const SizedBox(height: 24),

           SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: _isLoading ? null : () async {
                if (_selectedClient == null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Selecione um cliente")));
                  return;
                }

                setState(() => _isLoading = true);
                final loginController = Provider.of<LoginController>(context, listen: false);
                final token = loginController.token;

                final Map<String, int> sizes = {};
                _sizeControllers.forEach((size, controller) {
                  final qtd = int.tryParse(controller.text) ?? 0;
                  if (qtd > 0) sizes[size] = qtd;
                });

                if (sizes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Informe ao menos um tamanho com quantidade > 0")),
                  );
                  setState(() => _isLoading = false);
                  return;
                }

                final unitPrice = double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;
                final totalQuantity = sizes.values.fold(0, (a, b) => a + b);
                final subtotal = totalQuantity * unitPrice;

                final item = OrderItem(
                  soleName: _itemController.text.trim(),
                  soleColor: _corController.text.trim(),
                  unitPrice: unitPrice,
                  sizes: sizes,
                  totalQuantity: totalQuantity,
                  subtotal: subtotal,
                );

                final novoPedido = Pedido.createLocal(
                  customerId: _selectedClient!.id,
                  cliente: _selectedClient,
                  items: [item],
                  totalAmount: subtotal,
                  observations:
                      _obsController.text.trim().isEmpty ? null : _obsController.text.trim(),
                );

                final pedidoController =
                    Provider.of<PedidoController>(context, listen: false);
                final sucesso = await pedidoController.adicionarNovoPedido(
                  novoPedido,
                  token: token,
                );

                if (!mounted) return;
                setState(() => _isLoading = false);

                if (sucesso) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Pedido salvo com sucesso!')));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Erro ao salvar pedido!')));
                }
              },
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text("Salvar Pedido"),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
