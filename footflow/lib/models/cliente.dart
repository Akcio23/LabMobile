
class Address {
  String street;
  String number;
  String neighborhood;

  Address({
    required this.street,
    required this.number,
    required this.neighborhood,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      number: json['number'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'street': street,
        'number': number,
        'neighborhood': neighborhood,
      };
}

class Cliente {
  final String id;
  String nome;
  String telefone;
  String cnpjCpf;
  Address address;
  String email;

  Cliente({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.cnpjCpf,
    required this.address,
    required this.email,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['_id']?.toString() ?? '',
      nome: json['name'] ?? '',
      telefone: json['phone'] ?? '',
      cnpjCpf: json['cnpjCpf'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': nome,
        'cnpjCpf': cnpjCpf,
        'address': address.toJson(),
        'phone': telefone,
        'email': email,
      };

  Map<String, dynamic> toJsonForUpdate() => {
        'id': id,
        'name': nome,
        'cnpjCpf': cnpjCpf,
        'address': address.toJson(),
        'phone': telefone,
        'email': email,
      };
}