import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/pedido_controller.dart';
import 'controllers/cliente_controller.dart';
import 'controllers/login_controller.dart';
import 'views/login_screen.dart';
import 'views/dashboard_screen.dart';
import 'views/PedidosScreen.dart';
import 'views/new_pedido_screen.dart';
import 'views/new_client_screen.dart';
import 'views/clientes_screen.dart';
import 'views/configuracoes_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => PedidoController()),
        ChangeNotifierProvider(create: (_) => ClienteController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestão de Pedidos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/pedidos': (context) => const PedidosScreen(),
        '/clientes': (context) => const ClientesScreen(),
        '/configuracoes': (context) => const ConfiguracoesScreen(),
        '/new-pedido': (context) => const NewPedidoScreen(),
        '/new-client': (context) => const NewClientScreen(),
      },
    );
  }
}