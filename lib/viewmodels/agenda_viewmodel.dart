import 'package:flutter/material.dart';
import '../models/turno.dart';

class AgendaViewModel extends ChangeNotifier {
  DateTime _fechaSeleccionada = DateTime.now();
  DateTime get fechaSeleccionada => _fechaSeleccionada;

  String? _filtroEstilistaId;
  String? get filtroEstilistaId => _filtroEstilistaId;

  EstadoTurno? _filtroEstado;
  EstadoTurno? get filtroEstado => _filtroEstado;

  void cambiarFecha(DateTime nuevaFecha) {
    _fechaSeleccionada = nuevaFecha;
    notifyListeners();
  }

  void cambiarFiltroEstilista(String? estilistaId) {
    _filtroEstilistaId = estilistaId;
    notifyListeners();
  }

  void cambiarFiltroEstado(EstadoTurno? estado) {
    _filtroEstado = estado;
    notifyListeners();
  }
}