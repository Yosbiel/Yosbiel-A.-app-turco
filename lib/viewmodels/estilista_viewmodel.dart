import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/estilista.dart';
import '../models/turno.dart';

class EstilistaViewModel extends ChangeNotifier {
  List<Estilista> get estilistas => MockData.estilistas;

  int turnosHoy(Estilista estilista) {
    final hoy = DateTime.now();
    return MockData.turnos.where((turno) {
      return turno.estilista.id == estilista.id &&
             turno.estado == EstadoTurno.programado &&
             turno.fechaHoraInicio.year == hoy.year &&
             turno.fechaHoraInicio.month == hoy.month &&
             turno.fechaHoraInicio.day == hoy.day;
    }).length;
  }
}