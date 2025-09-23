import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({required this.currentIndex, super.key});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(context, '/pedidos', (route) => false);
        break;
      case 2:
        // Ação para a tela de Clientes
        Navigator.pushNamedAndRemoveUntil(context, '/clientes', (route) => false);
        break;
      case 3:
        // Ação para a tela de Configurações
        Navigator.pushNamedAndRemoveUntil(context, '/configuracoes', (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[600],
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Clientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configurações',
        ),
      ],
    );
  }
}