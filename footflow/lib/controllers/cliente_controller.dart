import 'package:flutter/material.dart';
import '../models/cliente.dart';

class ClienteController with ChangeNotifier {
  // Dados simulados de clientes
  final List<Cliente> _clientes = [
    Cliente(id: '1', nome: 'Calçados Silva', telefone: '11 98765-4321'),
    Cliente(id: '2', nome: 'Esporte Total', telefone: '11 91234-5678'),
    Cliente(id: '3', nome: 'Sapataria Ideal', telefone: '(11) 95555-4444'),
  ];

  List<Cliente> get clientes => _clientes;

  void adicionarNovoCliente(Cliente novoCliente) {
    _clientes.add(novoCliente);
    notifyListeners();
  }

  void atualizarCliente(Cliente clienteAtualizado) {
    final index = _clientes.indexWhere((c) => c.id == clienteAtualizado.id);
    if (index != -1) {
      _clientes[index].nome = clienteAtualizado.nome;
      _clientes[index].telefone = clienteAtualizado.telefone;
      notifyListeners();
    }
  }
  
}