import 'package:flutter/material.dart';

class LoginController with ChangeNotifier {
  // Simulando um usuário válido
  final String _validUsername = 'user';
  final String _validPassword = '123';

  bool _isLoggedIn = false;
  bool _loginFailed = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get loginFailed => _loginFailed;

  Future<void> login(String username, String password) async {
    // Simula um delay para imitar uma requisição de rede
    await Future.delayed(const Duration(seconds: 2));

    if (username == _validUsername && password == _validPassword) {
      _isLoggedIn = true;
      _loginFailed = false;
    } else {
      _isLoggedIn = false;
      _loginFailed = true;
    }
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _loginFailed = false;
    notifyListeners();
  }
}