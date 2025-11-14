import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cliente_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import 'new_client_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    final clienteController = Provider.of<ClienteController>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('[ClientesScreen] Nenhum token encontrado. Usuário precisa fazer login.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sessão expirada. Faça login novamente.')),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    print('[ClientesScreen] Token carregado: $token');
    await clienteController.carregarClientes(token: token);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clienteController = Provider.of<ClienteController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clientes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 26),
            tooltip: 'Adicionar cliente',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewClientScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : clienteController.clientes.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum cliente cadastrado ainda.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarClientes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: clienteController.clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clienteController.clientes[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              cliente.nome.isNotEmpty
                                  ? cliente.nome[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          title: Text(
                            cliente.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // const Icon(Icons.phone, size: 15, color: Colors.grey),
                                    // const SizedBox(width: 5),
                                    Text(
                                      cliente.telefone,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                if (cliente.email.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.email_outlined, size: 15, color: Colors.grey),
                                        const SizedBox(width: 5),
                                        Text(
                                          cliente.email,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (cliente.cnpjCpf.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.badge_outlined, size: 15, color: Colors.grey),
                                        const SizedBox(width: 5),
                                        Text(
                                          cliente.cnpjCpf,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            // tooltip: 'Editar cliente',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewClientScreen(clienteParaEdicao: cliente),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
