import 'package:flutter/material.dart';
import '../data/mock_data.dart';
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

  // Lista filtrada y ordenada para la vista
  List<Turno> get turnosDelDia {
    final lista = MockData.turnos.where((turno) {
      final esDelDia = turno.fechaHoraInicio.year == _fechaSeleccionada.year &&
                       turno.fechaHoraInicio.month == _fechaSeleccionada.month &&
                       turno.fechaHoraInicio.day == _fechaSeleccionada.day;
      
      final cumpleEstilista = _filtroEstilistaId == null || turno.estilista.id == _filtroEstilistaId;
      final cumpleEstado = _filtroEstado == null || turno.estado == _filtroEstado;
      
      return esDelDia && cumpleEstilista && cumpleEstado;
    }).toList();

    // Ordenar por hora
    lista.sort((a, b) => a.fechaHoraInicio.compareTo(b.fechaHoraInicio));
    return lista;
  }

  // Contadores para el resumen
  int get cantidadProgramados {
    return MockData.turnos.where((t) => 
      t.fechaHoraInicio.day == _fechaSeleccionada.day && 
      t.estado == EstadoTurno.programado
    ).length;
  }

  int get cantidadCompletados {
    return MockData.turnos.where((t) => 
      t.fechaHoraInicio.day == _fechaSeleccionada.day && 
      t.estado == EstadoTurno.completado
    ).length;
  }

  double get ingresoEstimado {
    return MockData.turnos.where((t) => 
      t.fechaHoraInicio.day == _fechaSeleccionada.day && 
      (t.estado == EstadoTurno.programado || t.estado == EstadoTurno.completado)
    ).fold(0.0, (sum, t) => sum + t.precioTotal);
  }
}