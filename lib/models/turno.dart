import 'cliente.dart';
import 'estilista.dart';
import 'servicio.dart';

enum EstadoTurno { programado, completado, cancelado }

class Turno {
  final String id;
  final Cliente cliente;
  final Estilista estilista;
  final List<Servicio> servicios;
  final DateTime fechaHoraInicio;
  final String? notas;
  final EstadoTurno estado;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  Turno({
    required this.id,
    required this.cliente,
    required this.estilista,
    required this.servicios,
    required this.fechaHoraInicio,
    this.notas,
    required this.estado,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  // Reglas de negocio calculadas
  int get duracionTotalMinutos => servicios.fold(0, (sum, s) => sum + s.duracionMinutos);
  
  DateTime get fechaHoraFin => fechaHoraInicio.add(Duration(minutes: duracionTotalMinutos));
  
  double get precioTotal => servicios.fold(0.0, (sum, s) => sum + s.precio);
}