import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cliente_controller.dart';
import '../controllers/login_controller.dart';
import '../models/cliente.dart';
import 'package:flutter/services.dart';
import '../utils/phone_input_formatter.dart';

class NewClientScreen extends StatefulWidget {
  final Cliente? clienteParaEdicao;

  const NewClientScreen({this.clienteParaEdicao, super.key});

  @override
  State<NewClientScreen> createState() => _NewClientScreenState();
}

class _NewClientScreenState extends State<NewClientScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.clienteParaEdicao != null) {
      _nomeController.text = widget.clienteParaEdicao!.nome;
      _telefoneController.text = widget.clienteParaEdicao!.telefone;
      _cnpjController.text = widget.clienteParaEdicao!.cnpjCpf;
      _emailController.text = widget.clienteParaEdicao!.email;

      final addr = widget.clienteParaEdicao!.address;
      _streetController.text = addr.street;
      _numberController.text = addr.number;
      _neighborhoodController.text = addr.neighborhood;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _cnpjController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _emailController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nome', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    hintText: 'Nome do cliente',
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 16.0),

                const Text('CNPJ / CPF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _cnpjController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'CNPJ ou CPF',
                    prefixIcon: const Icon(Icons.assignment_ind_outlined, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe CNPJ/CPF' : null,
                ),
                const SizedBox(height: 16.0),

                const Text('Endereço', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(
                    hintText: 'Rua',
                    prefixIcon: const Icon(Icons.location_city_outlined, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a rua' : null,
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    hintText: 'Número',
                    prefixIcon: const Icon(Icons.format_list_numbered_outlined, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o número' : null,
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _neighborhoodController,
                  decoration: InputDecoration(
                    hintText: 'Bairro',
                    prefixIcon: const Icon(Icons.map_outlined, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o bairro' : null,
                ),
                const SizedBox(height: 8.0),

                const Text(
                  'Telefone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, 
                    PhoneInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: '(00) 00000-0000',
                    prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Informe o telefone'
                      : null,
                ),
                const SizedBox(height: 16.0),

                const Text('E-mail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'email@exemplo.com',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                    final emailReg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
                    if (!emailReg.hasMatch(v)) return 'E-mail inválido';
                    return null;
                  },
                ),

                const SizedBox(height: 24.0),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            setState(() => _isLoading = true);

                            final clienteController = Provider.of<ClienteController>(context, listen: false);
                            final loginController = Provider.of<LoginController>(context, listen: false);
                            final token = loginController.token;

                            print('[NewClientScreen] token from login: $token (length: ${token.length})');

                            final addressObj = Address(
                              street: _streetController.text.trim(),
                              number: _numberController.text.trim(),
                              neighborhood: _neighborhoodController.text.trim(),
                            );

                            bool ok;
                            try {
                              if (widget.clienteParaEdicao != null) {
                                widget.clienteParaEdicao!
                                  ..nome = _nomeController.text
                                  ..telefone = _telefoneController.text
                                  ..cnpjCpf = _cnpjController.text
                                  ..address = addressObj
                                  ..email = _emailController.text;
                                ok = await clienteController.atualizarCliente(widget.clienteParaEdicao!, token: token);
                              } else {
                                final novoCliente = Cliente(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  nome: _nomeController.text,
                                  telefone: _telefoneController.text,
                                  cnpjCpf: _cnpjController.text,
                                  address: addressObj,
                                  email: _emailController.text,
                                );
                                ok = await clienteController.adicionarNovoCliente(novoCliente, token: token);
                              }
                            } catch (e) {
                              print('[NewClientScreen] error: $e');
                              ok = false;
                            }

                            if (!mounted) return;
                            setState(() => _isLoading = false);

                            if (ok) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cliente salvo com sucesso')),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro ao salvar cliente')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(widget.clienteParaEdicao != null ? 'Salvar Alterações' : 'Salvar Cliente',
                            style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
