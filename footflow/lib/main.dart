import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/pedido_controller.dart';
import 'controllers/cliente_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/register_controller.dart';
import 'views/register_screen.dart';
import 'views/login_screen.dart';
import 'views/dashboard_screen.dart';
import 'views/pedidos_screen.dart';
import 'views/new_pedido_screen.dart';
import 'views/new_client_screen.dart';
import 'views/clientes_screen.dart';
import 'views/configuracoes_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:firebase_analytics/observer.dart'; 
import 'package:firebase_analytics/firebase_analytics.dart'; 

void main() async { 
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => RegisterController()),
        ChangeNotifierProvider(create: (_) => PedidoController()),
        ChangeNotifierProvider(create: (_) => ClienteController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestão de Pedidos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorObservers: [observer],
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const CreateAccountScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/pedidos': (context) => const PedidosScreen(),
        '/clientes': (context) => const ClientesScreen(),
        '/configuracoes': (context) => const ConfiguracoesScreen(),
        '/new-client': (context) => const NewClientScreen(),
        '/new-pedido': (context) => const NewPedidoScreen(),
      },
    );
  }
}