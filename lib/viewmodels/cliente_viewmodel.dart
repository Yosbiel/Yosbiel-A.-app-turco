import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/cliente.dart';
import '../models/turno.dart';

class ClienteViewModel extends ChangeNotifier {
  String _busqueda = '';
  Genero? _filtroGenero;

  String get busqueda => _busqueda;
  Genero? get filtroGenero => _filtroGenero;

  void cambiarBusqueda(String texto) {
    _busqueda = texto;
    notifyListeners();
  }

  void cambiarFiltroGenero(Genero? genero) {
    _filtroGenero = genero;
    notifyListeners();
  }

  String _normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');
  }

  List<Cliente> get clientesFiltrados {
    return MockData.clientes.where((cliente) {
      final cumpleGenero =
          _filtroGenero == null || cliente.genero == _filtroGenero;

      final nombreNormalizado = _normalizar(cliente.nombre);
      final busquedaNormalizada = _normalizar(_busqueda);
      final cumpleBusqueda =
          nombreNormalizado.contains(busquedaNormalizada) ||
              cliente.telefono.contains(_busqueda);

      return cumpleGenero && cumpleBusqueda;
    }).toList();
  }

  int get totalClientes => MockData.clientes.length;
  int get totalMujeres =>
      MockData.clientes.where((c) => c.genero == Genero.mujer).length;
  int get totalHombres =>
      MockData.clientes.where((c) => c.genero == Genero.hombre).length;

  int obtenerTurnosCliente(String clienteId) {
    return MockData.turnos.where((t) => t.cliente.id == clienteId).length;
  }

  List<Turno> historialCliente(String clienteId) {
    final lista = MockData.turnos
        .where((t) => t.cliente.id == clienteId)
        .toList();
    lista.sort((a, b) => b.fechaHoraInicio.compareTo(a.fechaHoraInicio));
    return lista;
  }

  bool telefonoExiste(String telefono, {String? excluirClienteId}) {
    return MockData.clientes.any((c) =>
        c.telefono == telefono && c.id != excluirClienteId);
  }

  void agregarCliente(Cliente cliente) {
    MockData.clientes.add(cliente);
    notifyListeners();
  }

  void actualizarCliente(Cliente cliente) {
    final index = MockData.clientes.indexWhere((c) => c.id == cliente.id);
    if (index != -1) {
      MockData.clientes[index] = cliente;
      notifyListeners();
    }
  }

  bool tieneTurnosProgramados(String clienteId) {
    return MockData.turnos.any((t) =>
        t.cliente.id == clienteId && t.estado == EstadoTurno.programado);
  }

  void eliminarCliente(String clienteId) {
    MockData.clientes.removeWhere((c) => c.id == clienteId);
    MockData.turnos.removeWhere((t) => t.cliente.id == clienteId);
    notifyListeners();
  }
}