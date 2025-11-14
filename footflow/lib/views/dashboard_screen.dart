import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pedido_controller.dart';
import 'package:footflow/widgets/bottom_nav_bar.dart';
import 'package:firebase_performance/firebase_performance.dart'; 
import 'package:firebase_analytics/firebase_analytics.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  
@override
  Widget build(BuildContext context) {
    final trace = FirebasePerformance.instance.newTrace('render_dashboard_page');
    trace.start();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      trace.stop();
    });

    final pedidoController = Provider.of<PedidoController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _StatisticCard(title: 'Novo', value: pedidoController.novosPedidos.toString(), backgroundColor: const Color(0xFFE3F2FD), valueColor: Colors.blue),
                  _StatisticCard(title: 'Em produção', value: pedidoController.emProducaoPedidos.toString(), backgroundColor: const Color(0xFFFFF3E0), valueColor: Colors.deepOrange),
                  _StatisticCard(title: 'Concluído', value: pedidoController.concluidosPedidos.toString(), backgroundColor: const Color(0xFFE8F5E9), valueColor: Colors.green),
                  _StatisticCard(title: 'Entregue', value: pedidoController.entreguesPedidos.toString(), backgroundColor: const Color(0xFFEEEEEE), valueColor: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'btn_criar_pedido_clicado',
                    parameters: {'origem': 'dashboard'},
                  );
                  Navigator.pushNamed(context, '/new-pedido');
                },
                icon: const Icon(Icons.add),
                label: const Text('Criar Novo Pedido', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final Color valueColor;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0, 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
