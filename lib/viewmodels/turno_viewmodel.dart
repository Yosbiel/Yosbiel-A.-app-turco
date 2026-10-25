import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/turno.dart';
import '../models/servicio.dart';
import '../models/estilista.dart';
import '../models/cliente.dart';

class TurnoViewModel extends ChangeNotifier {
  
  List<DateTime> obtenerHorasDisponibles(DateTime fecha, Estilista estilista, Cliente? cliente, List<Servicio> servicios) {
    List<DateTime> horas = [];
    
    if (fecha.weekday == DateTime.sunday) return horas;

    int duracionTotal = 0;
    for (var s in servicios) {
      duracionTotal += s.duracionMinutos;
    }
    if (duracionTotal == 0) return horas;

    DateTime horaActual = DateTime(fecha.year, fecha.month, fecha.day, 9, 0);
    DateTime finJornada = DateTime(fecha.year, fecha.month, fecha.day, 19, 0);

    while (horaActual.isBefore(finJornada)) {
      DateTime horaFin = horaActual.add(Duration(minutes: duracionTotal));

      if (horaFin.isAfter(finJornada)) break;
      if (horaActual.isBefore(DateTime.now())) {
        horaActual = horaActual.add(const Duration(minutes: 30));
        continue;
      }

      bool ocupado = false;
      for (var t in MockData.turnos) {
        if (t.estado == EstadoTurno.cancelado) continue;
        
        bool mismoEstilista = t.estilista.id == estilista.id;
        bool mismoCliente = cliente != null && t.cliente.id == cliente.id;

        if (mismoEstilista || mismoCliente) {
          bool seCruzan = horaActual.isBefore(t.fechaHoraFin) && horaFin.isAfter(t.fechaHoraInicio);
          if (seCruzan) {
            ocupado = true;
            break;
          }
        }
      }

      if (!ocupado) {
        horas.add(horaActual);
      }
      horaActual = horaActual.add(const Duration(minutes: 30));
    }
    return horas;
  }

  void guardarTurno(Turno turno) {
    // Buscamos si ya existe para editarlo, si no, lo agregamos
    int index = MockData.turnos.indexWhere((t) => t.id == turno.id);
    if (index != -1) {
      MockData.turnos[index] = turno;
    } else {
      MockData.turnos.add(turno);
    }
    notifyListeners();
  }

  void cambiarEstado(String idTurno, EstadoTurno nuevoEstado) {
    int index = MockData.turnos.indexWhere((t) => t.id == idTurno);
    if (index != -1) {
      Turno t = MockData.turnos[index];
      MockData.turnos[index] = Turno(
        id: t.id,
        cliente: t.cliente,
        estilista: t.estilista,
        servicios: t.servicios,
        fechaHoraInicio: t.fechaHoraInicio,
        notas: t.notas,
        estado: nuevoEstado,
        fechaCreacion: t.fechaCreacion,
        fechaModificacion: DateTime.now(),
      );
      notifyListeners();
    }
  }
}