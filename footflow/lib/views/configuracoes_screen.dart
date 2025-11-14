import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart'; 

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: ListTile(
                leading: const Icon(Icons.lock_outline, color: Colors.blue),
                title: const Text('Alterar Senha'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                },
              ),
            ),
            const SizedBox(height: 12.0),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.blue),
                title: const Text('Gerenciamento de Perfil'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                },
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}