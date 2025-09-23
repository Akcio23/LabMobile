import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart'; // Importa o widget da barra de navegação

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Item "Alterar Senha"
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
                  // Ação para ir para a tela de Alterar Senha
                },
              ),
            ),
            const SizedBox(height: 12.0),

            // Item "Gerenciamento de Perfil"
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
                  // Ação para ir para a tela de Gerenciamento de Perfil
                },
              ),
            ),
            const SizedBox(height: 12.0),

            // Item "Informações sobre o Aplicativo"
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.blue),
                title: const Text('Informações sobre o Aplicativo'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Ação para ir para a tela de Informações
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}