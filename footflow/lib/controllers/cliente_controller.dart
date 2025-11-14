import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cliente.dart';

class ClienteController with ChangeNotifier {
  List<Cliente> _clientes = [];

  List<Cliente> get clientes => _clientes;

  static const String _baseUrl = 'http://192.168.100.144:3000/client/customers';

  Map<String, String> _getAuthHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<void> carregarClientes({required String token}) async {
    try {
      final url = Uri.parse(_baseUrl);
      final response = await http.get(url, headers: _getAuthHeaders(token));

      print('[ClienteController] GET ${response.statusCode} -> ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map && data.containsKey('customers')) {
        final customersList = data['customers'] as List;
        _clientes = customersList.map((e) => Cliente.fromJson(e)).toList();
        notifyListeners();

      } else if (data is List) {
        _clientes = data.map((e) => Cliente.fromJson(e)).toList();
        notifyListeners();
      }
    } else {
      print('[ClienteController] Erro ao carregar clientes: ${response.statusCode}');
    }
    } catch (e) {
      print('[ClienteController] carregarClientes error: $e');
    }
  }

  Future<bool> adicionarNovoCliente(Cliente novoCliente, {required String token}) async {
    try {
      final url = Uri.parse(_baseUrl);
      final jsonBody = jsonEncode(novoCliente.toJson());
      final headers = _getAuthHeaders(token);

      print('[ClienteController] POST body: $jsonBody');
      final response = await http.post(url, headers: headers, body: jsonBody);

      print('[ClienteController] POST ${response.statusCode} -> ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final clienteCriado = Cliente.fromJson(data);
        _clientes.add(clienteCriado);
        notifyListeners();
        return true;
      } else {
        print('[ClienteController] Erro ao adicionar cliente: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('[ClienteController] adicionarNovoCliente error: $e');
      return false;
    }
  }

  Future<bool> atualizarCliente(Cliente clienteAtualizado, {required String token}) async {
    try {
      final url = Uri.parse('$_baseUrl/${clienteAtualizado.id}');
      final jsonBody = jsonEncode(clienteAtualizado.toJson());
      final headers = _getAuthHeaders(token);

      print('[ClienteController] PUT body: $jsonBody');
      final response = await http.put(url, headers: headers, body: jsonBody);

      print('[ClienteController] PUT ${response.statusCode} -> ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        final index = _clientes.indexWhere((c) => c.id == clienteAtualizado.id);

        if (index != -1) {
          _clientes[index] = clienteAtualizado;
          notifyListeners();
        }
        return true;
      } else {
        print('[ClienteController] Erro ao atualizar cliente: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('[ClienteController] atualizarCliente error: $e');
      return false;
    }
  }

  Future<bool> removerCliente(String id, {required String token}) async {
    try {
      final url = Uri.parse('$_baseUrl/$id');
      final response = await http.delete(url, headers: _getAuthHeaders(token));

      print('[ClienteController] DELETE ${response.statusCode} -> ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        _clientes.removeWhere((c) => c.id == id);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('[ClienteController] removerCliente error: $e');
      return false;
    }
  }
}
