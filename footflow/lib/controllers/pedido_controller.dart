// lib/controllers/pedido_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../models/pedido.dart';

class PedidoController with ChangeNotifier {
  final List<Pedido> _pedidos = [];
  List<Pedido> get pedidos => _pedidos;

  final String _baseUrl = 'http://192.168.100.144:3000/requests/orders';

  Future<void> buscarPedidos({required String token}) async {
    final trace = FirebasePerformance.instance.newTrace('get_orders');
    await trace.start();
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('[PedidoController] GET ${response.statusCode} -> ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> list = [];
        if (decoded is Map && decoded.containsKey('orders')) {
          list = decoded['orders'] as List<dynamic>;
        } else if (decoded is List) {
          list = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          list = decoded['data'] as List<dynamic>;
        } else {
          list = [];
        }

        _pedidos
          ..clear()
          ..addAll(list.map((json) => Pedido.fromJson(Map<String, dynamic>.from(json))));
        notifyListeners();
      } else {
        debugPrint('Erro ao buscar pedidos: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro na requisição de pedidos: $e');
    } finally {
      await trace.stop();
    }
  }

  Future<bool> adicionarNovoPedido(Pedido novoPedido, {required String token}) async {
    final trace = FirebasePerformance.instance.newTrace('create_new_order');
    await trace.start();
    try {
      final uri = Uri.parse(_baseUrl);
      final body = novoPedido.toApiJson();

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('[PedidoController] POST ${response.statusCode} -> ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map) {
            final created = Pedido.fromJson(Map<String, dynamic>.from(decoded));
            _pedidos.add(created);
          } else {
            _pedidos.add(novoPedido);
          }
        } catch (_) {
          _pedidos.add(novoPedido);
        }

        notifyListeners();

        await FirebaseAnalytics.instance.logEvent(
          name: 'pedido_criado',
          parameters: {
            'items_count': novoPedido.items.length,
            'total': novoPedido.totalAmount,
          },
        );

        return true;
      } else {
        debugPrint('Erro ao criar pedido: ${response.statusCode} -> ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Erro ao adicionar pedido: $e');
      return false;
    } finally {
      await trace.stop();
    }
  }

  Future<bool> atualizarStatusPedido(
    String pedidoId,
    String novoStatus, {
    required String token,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$pedidoId/status'); 
      final response = await http.patch(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': novoStatus}),
      );

      debugPrint('[PedidoController] PATCH ${response.statusCode} -> ${response.body}');

      if (response.statusCode == 200) {
        final pedidoIndex = _pedidos.indexWhere((p) => p.id == pedidoId);
        if (pedidoIndex != -1) {
          final old = _pedidos[pedidoIndex];
          _pedidos[pedidoIndex] = Pedido(
            id: old.id,
            customerId: old.customerId,
            orderNumber: old.orderNumber,
            cliente: old.cliente,
            status: novoStatus,
            items: old.items,
            totalAmount: old.totalAmount,
            observations: old.observations,
            createdAt: old.createdAt,
            updatedAt: DateTime.now(),
          );
          notifyListeners();
        }

        await FirebaseAnalytics.instance.logEvent(
          name: 'status_pedido_atualizado',
          parameters: {'pedido_id': pedidoId, 'novo_status': novoStatus},
        );

        return true;
      } else {
        debugPrint('Erro ao atualizar status: ${response.statusCode} -> ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Erro ao atualizar status pedido: $e');
      return false;
    }
  }

  int get novosPedidos => _pedidos.where((p) => p.status == 'pendente' || p.status == 'Novo').length;
  int get emProducaoPedidos => _pedidos.where((p) => p.status == 'em_producao' || p.status == 'Em Produção').length;
  int get concluidosPedidos => _pedidos.where((p) => p.status == 'finalizado' || p.status == 'Concluído').length;
  int get entreguesPedidos => _pedidos.where((p) => p.status == 'entregue' || p.status == 'Entregue').length;
}
