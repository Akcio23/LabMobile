import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../models/cliente.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class PedidoController with ChangeNotifier {
  // Dados simulados com campo 'previsao'
  final List<Pedido> _pedidos = [
    Pedido(
      id: '12345',
      item: 'Sapato Social',
      quantidade: 5,
      data: DateTime.now(),
      previsao: DateTime.now().add(const Duration(days: 5)),
      status: 'Novo',
      cliente: Cliente(id: '1', nome: 'Calçados Silva', telefone: ''),
    ),
    Pedido(
      id: '12346',
      item: 'Tênis Esportivo',
      quantidade: 10,
      data: DateTime.now(),
      previsao: DateTime.now().add(const Duration(days: 7)),
      status: 'Em Produção',
      cliente: Cliente(id: '2', nome: 'Esporte Total', telefone: ''),
    ),
    Pedido(
      id: '12347',
      item: 'Sapatilha',
      quantidade: 8,
      data: DateTime.now(),
      previsao: DateTime.now().add(const Duration(days: 3)),
      status: 'Concluído',
      cliente: Cliente(id: '1', nome: 'Calçados Silva', telefone: ''),
    ),
    Pedido(
      id: '12348',
      item: 'Chuteira',
      quantidade: 3,
      data: DateTime.now(),
      previsao: DateTime.now().add(const Duration(days: 6)),
      status: 'Novo',
      cliente: Cliente(id: '2', nome: 'Esporte Total', telefone: ''),
    ),
    Pedido(
      id: '12349',
      item: 'Bota',
      quantidade: 7,
      data: DateTime.now(),
      previsao: DateTime.now().add(const Duration(days: 10)),
      status: 'Em Produção',
      cliente: Cliente(id: '1', nome: 'Calçados Silva', telefone: ''),
    ),
    Pedido(
      id: '12350',
      item: 'Sandália',
      quantidade: 20,
      data: DateTime.now(),
      previsao: DateTime.now().add(const Duration(days: 4)),
      status: 'Concluído',
      cliente: Cliente(id: '3', nome: 'Sapataria Ideal', telefone: ''),
    ),
    Pedido(
      id: '12351',
      item: 'Chinelo',
      quantidade: 15,
      data: DateTime.now(),
      previsao: DateTime.now().add(const Duration(days: 1)),
      status: 'Entregue',
      cliente: Cliente(id: '3', nome: 'Sapataria Ideal', telefone: ''),
    ),
  ];

  List<Pedido> get pedidos => _pedidos;

  void adicionarNovoPedido(Pedido novoPedido) async { // Mude para async
    final trace = FirebasePerformance.instance.newTrace('create_new_order');
    await trace.start();

    // Simulação da API
    await Future.delayed(const Duration(milliseconds: 500)); 

    _pedidos.add(novoPedido);
    
    await FirebaseAnalytics.instance.logEvent(
        name: 'pedido_criado',
        parameters: {'item_nome': novoPedido.item, 'quantidade': novoPedido.quantidade}
    );

    await trace.stop();
    notifyListeners();
}

void atualizarStatusPedido(String pedidoId, String novoStatus) async { // Mude para async
    final pedidoIndex = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (pedidoIndex != -1) {
        
        // APENAS ANALYTICS (sem trace, pois é uma operação rápida)
        await FirebaseAnalytics.instance.logEvent(
            name: 'status_pedido_atualizado',
            parameters: {'pedido_id': pedidoId, 'novo_status': novoStatus}
        );
        
        _pedidos[pedidoIndex].status = novoStatus;
        notifyListeners(); 
    }
}

  int get novosPedidos => _pedidos.where((p) => p.status == 'Novo').length;
  int get emProducaoPedidos => _pedidos.where((p) => p.status == 'Em Produção').length;
  int get concluidosPedidos => _pedidos.where((p) => p.status == 'Concluído').length;
  int get entreguesPedidos => _pedidos.where((p) => p.status == 'Entregue').length;
}
