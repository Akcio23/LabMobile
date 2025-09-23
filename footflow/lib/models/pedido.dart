import 'cliente.dart'; 

class Pedido {
  final String id;
  final String item;
  final int quantidade;
  final DateTime data;
  String status; 
  final Cliente cliente;
  final DateTime previsao;  // Adicionando o campo previsao

  Pedido({
    required this.id,
    required this.item,
    required this.quantidade,
    required this.data,
    required this.status,
    required this.cliente,
    required this.previsao,  // Incluindo previsao no construtor
  });

  // Método de conversão de JSON (para consumo de API)
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as String,
      item: json['item'] as String,
      quantidade: json['quantidade'] as int,
      data: DateTime.parse(json['data'] as String),
      status: json['status'] as String,
      cliente: Cliente.fromJson(json['cliente']), // Converte o JSON do cliente
      previsao: DateTime.parse(json['previsao'] as String), // Adicionando previsão no fromJson
    );
  }

  // Método de conversão para JSON (para enviar para a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item,
      'quantidade': quantidade,
      'data': data.toIso8601String(),
      'status': status,
      'cliente': cliente.toJson(), // Converte o cliente para JSON
      'previsao': previsao.toIso8601String(),  // Adicionando previsão no toJson
    };
  }
}
