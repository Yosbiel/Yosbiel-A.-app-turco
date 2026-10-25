import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/cliente.dart';

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

  // Función para quitar acentos y mayúsculas
  String _normalizar(String texto) {
    return texto.toLowerCase()
      .replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('í', 'i')
      .replaceAll('ó', 'o').replaceAll('ú', 'u').replaceAll('ñ', 'n');
  }

  List<Cliente> get clientesFiltrados {
    return MockData.clientes.where((cliente) {
      final cumpleGenero = _filtroGenero == null || cliente.genero == _filtroGenero;
      
      final nombreNormalizado = _normalizar(cliente.nombre);
      final busquedaNormalizada = _normalizar(_busqueda);
      final cumpleBusqueda = nombreNormalizado.contains(busquedaNormalizada) || 
                             cliente.telefono.contains(_busqueda);
      
      return cumpleGenero && cumpleBusqueda;
    }).toList();
  }

  int get totalClientes => MockData.clientes.length;
  int get totalMujeres => MockData.clientes.where((c) => c.genero == Genero.mujer).length;
  int get totalHombres => MockData.clientes.where((c) => c.genero == Genero.hombre).length;

  int obtenerTurnosCliente(String clienteId) {
    return MockData.turnos.where((t) => t.cliente.id == clienteId).length;
  }
}