import 'dart:async';
import 'package:footflow/models/pedido.dart';
import 'package:footflow/models/cliente.dart';

class DataService {
  Future<List<Pedido>> fetchPedidos() {
    // Simula um atraso de 1 segundo para imitar uma requisição de rede
    return Future.delayed(const Duration(seconds: 1), () {
      return [
        Pedido(
          id: '12345',
          item: 'Tênis Esportivo',
          quantidade: 10,
          data: DateTime.now(),
          previsao: DateTime.now().add(const Duration(days: 5)),
          status: 'Novo',
          cliente: Cliente(
            id: 'c1',
            nome: 'Calçados Silva',
            telefone: '(11) 99999-9999',
          ),
        ),
        Pedido(
          id: '12346',
          item: 'Sandália Feminina',
          quantidade: 5,
          data: DateTime.now().subtract(const Duration(days: 1)),
          previsao: DateTime.now().add(const Duration(days: 4)),
          status: 'Em Produção',
          cliente: Cliente(
            id: 'c1',
            nome: 'Calçados Silva',
            telefone: '(11) 99999-9999',
          ),
        ),
        Pedido(
          id: '12347',
          item: 'Bota Masculina',
          quantidade: 3,
          data: DateTime.now().subtract(const Duration(days: 2)),
          previsao: DateTime.now().add(const Duration(days: 2)),
          status: 'Concluído',
          cliente: Cliente(
            id: 'c1',
            nome: 'Calçados Silva',
            telefone: '(11) 99999-9999',
          ),
        ),
      ];
    });
  }

  // Métodos para criar, atualizar e deletar dados simulados
  Future<void> createPedido(Pedido novoPedido) {
    return Future.delayed(const Duration(seconds: 1), () {
      print('Simulando a criação de um novo pedido: ${novoPedido.id}');
    });
  }
}
