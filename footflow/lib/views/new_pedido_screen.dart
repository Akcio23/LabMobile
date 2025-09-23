import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pedido_controller.dart';
import '../controllers/cliente_controller.dart';
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
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _previsaoController = TextEditingController();

  DateTime? _dataPedido;
  DateTime? _dataPrevisao;

  @override
  Widget build(BuildContext context) {
    final clienteController = Provider.of<ClienteController>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Novo Pedido',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<Cliente>(
              value: _selectedClient,
              decoration: InputDecoration(
                labelText: 'Selecione o Cliente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              items: clienteController.clientes.map((Cliente cliente) {
                return DropdownMenuItem<Cliente>(
                  value: cliente,
                  child: Text(cliente.nome),
                );
              }).toList(),
              onChanged: (Cliente? newValue) {
                setState(() => _selectedClient = newValue);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Item do Pedido',
                suffixIcon: const Icon(Icons.content_copy, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade',
                suffixIcon: const Icon(Icons.filter_none, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16.0),

            // Data do Pedido
            TextFormField(
              controller: _dataController,
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _dataPedido = picked;
                    _dataController.text =
                        "${picked.day}/${picked.month}/${picked.year}";
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Data do Pedido',
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16.0),

            // Previsão
            TextFormField(
              controller: _previsaoController,
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 3)),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _dataPrevisao = picked;
                    _previsaoController.text =
                        "${picked.day}/${picked.month}/${picked.year}";
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Previsão de Entrega',
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedClient != null &&
                      _dataPedido != null &&
                      _dataPrevisao != null) {
                    final novoPedido = Pedido(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      item: _itemController.text,
                      quantidade:
                          int.tryParse(_quantidadeController.text) ?? 0,
                      data: _dataPedido!,
                      previsao: _dataPrevisao!, // <-- Aqui está o novo campo
                      status: 'Novo',
                      cliente: _selectedClient!,
                    );
                    Provider.of<PedidoController>(
                      context,
                      listen: false,
                    ).adicionarNovoPedido(novoPedido);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Salvar Pedido',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
