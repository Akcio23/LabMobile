import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cliente_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import 'new_client_screen.dart'; // Importe a tela de cliente

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clienteController = Provider.of<ClienteController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navega para a tela de Novo Cliente SEM passar um cliente
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewClientScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: clienteController.clientes.length,
        itemBuilder: (context, index) {
          final cliente = clienteController.clientes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              title: Text(cliente.nome),
              subtitle: Text(cliente.telefone),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // Navega para a tela de Editar Cliente PASSANDO o cliente
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewClientScreen(clienteParaEdicao: cliente),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}