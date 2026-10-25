import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/servicio.dart';

class ServicioViewModel extends ChangeNotifier {
  CategoriaServicio? _filtroCategoria;
  PublicoObjetivo? _filtroPublico;

  CategoriaServicio? get filtroCategoria => _filtroCategoria;
  PublicoObjetivo? get filtroPublico => _filtroPublico;

  void cambiarFiltroCategoria(CategoriaServicio? categoria) {
    _filtroCategoria = categoria;
    notifyListeners();
  }

  void cambiarFiltroPublico(PublicoObjetivo? publico) {
    _filtroPublico = publico;
    notifyListeners();
  }

  List<Servicio> get serviciosFiltrados {
    return MockData.servicios.where((servicio) {
      bool cumpleCategoria = _filtroCategoria == null || servicio.categoria == _filtroCategoria;
      bool cumplePublico = _filtroPublico == null || servicio.publico == _filtroPublico;
      return cumpleCategoria && cumplePublico;
    }).toList();
  }
}