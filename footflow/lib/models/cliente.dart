class Cliente {
  final String id;
  String nome;
  String telefone;

  Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
  });

  // Método de conversão de JSON
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as String,
      nome: json['nome'] as String,
      telefone: json['telefone'] as String,
    );
  }

  // Método de conversão para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
    };
  }
}