import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/turno.dart';
import '../models/servicio.dart';
import '../models/estilista.dart';
import '../models/cliente.dart';

class TurnoViewModel extends ChangeNotifier {
  // ====== Acceso de solo lectura ======
  List<Turno> get turnos => List.unmodifiable(MockData.turnos);

  Turno? buscarTurno(String id) {
    for (final t in MockData.turnos) {
      if (t.id == id) return t;
    }
    return null;
  }

  // ====== Listado filtrado por día + estilista + estado ======
  List<Turno> turnosDelDia({
    required DateTime fecha,
    String? estilistaId,
    EstadoTurno? estado,
  }) {
    final lista = MockData.turnos.where((t) {
      final mismoDia = t.fechaHoraInicio.year == fecha.year &&
          t.fechaHoraInicio.month == fecha.month &&
          t.fechaHoraInicio.day == fecha.day;
      final cumpleEstilista =
          estilistaId == null || t.estilista.id == estilistaId;
      final cumpleEstado = estado == null || t.estado == estado;
      return mismoDia && cumpleEstilista && cumpleEstado;
    }).toList();
    lista.sort((a, b) => a.fechaHoraInicio.compareTo(b.fechaHoraInicio));
    return lista;
  }

  // ====== Horas disponibles ======
  List<DateTime> obtenerHorasDisponibles(
    DateTime fecha,
    Estilista estilista,
    Cliente? cliente,
    List<Servicio> servicios, {
    String? idTurnoExcluir, // Para que al editar no cuente como solape
  }) {
    final horas = <DateTime>[];
    if (fecha.weekday == DateTime.sunday) return horas;

    int duracionTotal = 0;
    for (final s in servicios) {
      duracionTotal += s.duracionMinutos;
    }
    if (duracionTotal == 0) return horas;

    final ahora = DateTime.now();
    DateTime horaActual =
        DateTime(fecha.year, fecha.month, fecha.day, 9, 0);
    final finJornada =
        DateTime(fecha.year, fecha.month, fecha.day, 19, 0);

    while (horaActual.isBefore(finJornada)) {
      final horaFin = horaActual.add(Duration(minutes: duracionTotal));

      if (horaFin.isAfter(finJornada)) break;

      // Si la fecha es hoy y la hora ya pasó, saltar
      if (horaActual.isBefore(ahora)) {
        horaActual = horaActual.add(const Duration(minutes: 30));
        continue;
      }

      bool ocupado = false;
      for (final t in MockData.turnos) {
        if (t.estado == EstadoTurno.cancelado) continue;
        // Al editar, ignoramos el propio turno
        if (idTurnoExcluir != null && t.id == idTurnoExcluir) continue;

        final mismoEstilista = t.estilista.id == estilista.id;
        final mismoCliente =
            cliente != null && t.cliente.id == cliente.id;

        if (mismoEstilista || mismoCliente) {
          final seCruzan = horaActual.isBefore(t.fechaHoraFin) &&
              horaFin.isAfter(t.fechaHoraInicio);
          if (seCruzan) {
            ocupado = true;
            break;
          }
        }
      }

      if (!ocupado) horas.add(horaActual);
      horaActual = horaActual.add(const Duration(minutes: 30));
    }
    return horas;
  }

  // ====== Guardar (crear o editar) ======
  void guardarTurno(Turno turno) {
    final index = MockData.turnos.indexWhere((t) => t.id == turno.id);
    if (index != -1) {
      MockData.turnos[index] = turno;
    } else {
      MockData.turnos.add(turno);
    }
    notifyListeners(); // Notifica a TODAS las pantallas
  }

  // ====== Cambiar estado (completar / cancelar) ======
  void cambiarEstado(String idTurno, EstadoTurno nuevoEstado) {
    final index = MockData.turnos.indexWhere((t) => t.id == idTurno);
    if (index == -1) return;
    final t = MockData.turnos[index];
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