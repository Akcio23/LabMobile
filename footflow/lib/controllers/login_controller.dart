import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController with ChangeNotifier {

  bool _isLoggedIn = false;
  bool _loginFailed = false;
  String _token = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get loginFailed => _loginFailed;
  String get token => _token;

Future<void> login(String email, String password) async {
  final trace = FirebasePerformance.instance.newTrace('login_process_api');
  await trace.start();

  try {
    final url = Uri.parse('http://192.168.100.144:3000/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('[LoginController] HTTP ${response.statusCode} -> ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('[LoginController] parsed response: $data');

      bool isSuccess = false;
      String? receivedToken;

      if (data is Map) {
        if (data.containsKey('success')) {
          final s = data['success'];
          if (s == true || s == 'true' || s == 1 || s == '1') {
            isSuccess = true;
          }
        }

        if (data.containsKey('token') && data['token'] != null && data['token'].toString().isNotEmpty) {
          isSuccess = true;
          receivedToken = data['token'].toString();
        }

        if (!isSuccess && data.containsKey('message') && data['message'] != null) {
          final msg = data['message'].toString().toLowerCase();
          if (msg.contains('success') || msg.contains('successful')) {
            isSuccess = true;
          }
        }
      }

        if (isSuccess) {
          _isLoggedIn = true;
          _loginFailed = false;
          if (receivedToken != null) {
            _token = receivedToken;
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', _token);
              print('[LoginController] token persisted in SharedPreferences');
            } catch (e) {
              print('[LoginController] Erro ao salvar token localmente: $e');
            }
          }
        try {
          await FirebaseAnalytics.instance.logLogin(loginMethod: 'api');
        } catch (e) {
          print('[LoginController] Analytics logLogin error: $e');
        }
      } else {
        _isLoggedIn = false;
        _loginFailed = true;
      }
    } else {
      _isLoggedIn = false;
      _loginFailed = true;
    }
  } catch (e, st) {
    print('[LoginController] Exception during login: $e\n$st');
    _isLoggedIn = false;
    _loginFailed = true;
  } finally {
    try {
      await trace.stop();
    } catch (e) {
      print('[LoginController] trace.stop() error: $e');
    }
    notifyListeners();
  }
}

  void logout() {
    _isLoggedIn = false;
    _loginFailed = false;
    notifyListeners();
  }
}