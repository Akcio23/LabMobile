import 'order_item.dart';
import 'cliente.dart';

class Pedido {
  final String id; 
  final int? orderNumber;
  final String customerId; 
  final Cliente? cliente; 
  final String status;
  final List<OrderItem> items;
  final double totalAmount;
  final String? observations;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pedido({
    required this.id,
    required this.customerId,
    this.orderNumber,
    this.cliente,
    this.status = 'pendente',
    required this.items,
    this.totalAmount = 0.0,
    this.observations,
    this.createdAt,
    this.updatedAt,
  });

  factory Pedido.createLocal({
    required String customerId,
    Cliente? cliente,
    String status = 'pendente',
    required List<OrderItem> items,
    double totalAmount = 0.0,
    String? observations,
  }) {
    return Pedido(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerId: customerId,
      cliente: cliente,
      status: status,
      items: items,
      totalAmount: totalAmount,
      observations: observations,
      orderNumber: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    final List<OrderItem> parsedItems = [];
    if (json['items'] is List) {
      for (final e in json['items']) {
        parsedItems.add(OrderItem.fromJson(Map<String, dynamic>.from(e)));
      }
    }

    String customerId = '';
    Cliente? clienteObj;
    if (json['customer'] is String) {
      customerId = json['customer'];
    } else if (json['customer'] is Map) {
      final m = Map<String, dynamic>.from(json['customer']);
      customerId = m['_id']?.toString() ?? (m['id']?.toString() ?? '');
      try {
        clienteObj = Cliente.fromJson(m);
      } catch (e) {
        clienteObj = null;
      }
    } else if (json['customerId'] != null) {
      customerId = json['customerId'].toString();
    }

    return Pedido(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      orderNumber: json['orderNumber'] is int ? json['orderNumber'] : (json['orderNumber'] != null ? int.tryParse('${json['orderNumber']}') : null),
      customerId: customerId,
      cliente: clienteObj,
      status: json['status']?.toString() ?? 'pendente',
      items: parsedItems,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      observations: json['observations']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toApiJson() {
    return {
      'customer': customerId,
      'items': items.map((i) => i.toJson()).toList(),
      'totalAmount': totalAmount,
      if (observations != null) 'observations': observations,
      if (status.isNotEmpty) 'status': status,
    };
  }
}
