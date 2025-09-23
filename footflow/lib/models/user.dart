class User {
  final String username;
  final String password;
  final String token; // Geralmente retornado após o login

  User({
    required this.username,
    required this.password,
    required this.token,
  });

  // Métodos de conversão (opcional, mas útil para APIs)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'token': token,
    };
  }
}