import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cliente_controller.dart';
import '../models/cliente.dart';

class NewClientScreen extends StatefulWidget {
  final Cliente? clienteParaEdicao;

  const NewClientScreen({this.clienteParaEdicao, super.key});

  @override
  State<NewClientScreen> createState() => _NewClientScreenState();
}

class _NewClientScreenState extends State<NewClientScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preenche os campos se estiver em modo de edição
    if (widget.clienteParaEdicao != null) {
      _nomeController.text = widget.clienteParaEdicao!.nome;
      _telefoneController.text = widget.clienteParaEdicao!.telefone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String screenTitle = widget.clienteParaEdicao != null ? 'Editar Cliente' : 'Novo Cliente';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: Text(screenTitle, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nome', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8.0),
            TextFormField(controller: _nomeController, decoration: InputDecoration(hintText: 'Nome do cliente', prefixIcon: const Icon(Icons.person_outline, color: Colors.grey), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)), filled: true, fillColor: Colors.grey[100])),
            const SizedBox(height: 24.0),
            const Text('Telefone', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8.0),
            TextFormField(controller: _telefoneController, keyboardType: TextInputType.phone, decoration: InputDecoration(hintText: '(00) 00000-0000', prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: Colors.grey)), filled: true, fillColor: Colors.grey[100])),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final clienteController = Provider.of<ClienteController>(context, listen: false);

                  if (widget.clienteParaEdicao != null) {
                    // Modo de Edição
                    widget.clienteParaEdicao!.nome = _nomeController.text;
                    widget.clienteParaEdicao!.telefone = _telefoneController.text;
                    clienteController.atualizarCliente(widget.clienteParaEdicao!);
                  } else {
                    // Modo de Criação
                    final novoCliente = Cliente(id: DateTime.now().millisecondsSinceEpoch.toString(), nome: _nomeController.text, telefone: _telefoneController.text);
                    clienteController.adicionarNovoCliente(novoCliente);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
                child: Text(widget.clienteParaEdicao != null ? 'Salvar Alterações' : 'Salvar Cliente', style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}