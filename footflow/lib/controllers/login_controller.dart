import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
class LoginController with ChangeNotifier {
  // Simulando um usuário válido
  final String _validUsername = 'user';
  final String _validPassword = '123';

  bool _isLoggedIn = false;
  bool _loginFailed = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get loginFailed => _loginFailed;

  Future<void> login(String username, String password) async {
    final trace = FirebasePerformance.instance.newTrace('login_process_simulado');
    await trace.start();
    
    await Future.delayed(const Duration(seconds: 2));

    if (username == _validUsername && password == _validPassword) {
      _isLoggedIn = true;
      _loginFailed = false;
      
      await FirebaseAnalytics.instance.logLogin(loginMethod: 'app_credentials'); 
    } else {
      _isLoggedIn = false;
      _loginFailed = true;
    }
    
    await trace.stop(); 
    
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _loginFailed = false;
    notifyListeners();
  }
}