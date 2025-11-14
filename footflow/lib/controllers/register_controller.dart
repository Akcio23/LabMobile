import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';

class RegisterController with ChangeNotifier {
  bool _isLoading = false;
  bool _registerFailed = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get registerFailed => _registerFailed;
  String get errorMessage => _errorMessage;

  Future<bool> register(String name, String email, String password) async {
    print('Iniciando registro para: $name, $email');

    _isLoading = true;
    _registerFailed = false;
    _errorMessage = '';
    notifyListeners();


    try {
      final url = Uri.parse('http://192.168.100.144:3000/register');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _isLoading = false;
          _registerFailed = false;
          await FirebaseAnalytics.instance.logSignUp(signUpMethod: 'api');
          notifyListeners();
          return true;
        } else {
          _isLoading = false;
          _registerFailed = true;
          _errorMessage = data['message'] ?? 'Erro ao registrar';
          notifyListeners();
          return false;
        }
      } else {
        _isLoading = false;
        _registerFailed = true;
        _errorMessage = 'Erro na requisição: ${response.statusCode}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _registerFailed = true;
      _errorMessage = 'Erro de conexão: $e';
      notifyListeners();
      return false;
    }
  }
}