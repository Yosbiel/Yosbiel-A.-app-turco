import '../models/servicio.dart';
import '../models/estilista.dart';
import '../models/cliente.dart';
import '../models/turno.dart';

class MockData {
  static final List<Servicio> servicios = [
    Servicio(id: 's1', nombre: 'Corte Dama', categoria: CategoriaServicio.corte, duracionMinutos: 45, precio: 15.0, publico: PublicoObjetivo.mujeres),
    Servicio(id: 's2', nombre: 'Coloración', categoria: CategoriaServicio.color, duracionMinutos: 120, precio: 50.0, publico: PublicoObjetivo.mujeres),
    Servicio(id: 's3', nombre: 'Peinado de Fiesta', categoria: CategoriaServicio.peinado, duracionMinutos: 60, precio: 25.0, publico: PublicoObjetivo.mujeres),
    Servicio(id: 's4', nombre: 'Corte Caballero', categoria: CategoriaServicio.corte, duracionMinutos: 30, precio: 10.0, publico: PublicoObjetivo.hombres),
    Servicio(id: 's5', nombre: 'Arreglo de Barba', categoria: CategoriaServicio.barba, duracionMinutos: 30, precio: 8.0, publico: PublicoObjetivo.hombres),
    Servicio(id: 's6', nombre: 'Corte + Barba', categoria: CategoriaServicio.corte, duracionMinutos: 60, precio: 15.0, publico: PublicoObjetivo.hombres),
    Servicio(id: 's7', nombre: 'Lavado y Secado', categoria: CategoriaServicio.tratamiento, duracionMinutos: 20, precio: 5.0, publico: PublicoObjetivo.unisex),
    Servicio(id: 's8', nombre: 'Tratamiento Capilar', categoria: CategoriaServicio.tratamiento, duracionMinutos: 45, precio: 20.0, publico: PublicoObjetivo.unisex),
    Servicio(id: 's9', nombre: 'Corte Niño', categoria: CategoriaServicio.corte, duracionMinutos: 30, precio: 8.0, publico: PublicoObjetivo.unisex),
    Servicio(id: 's10', nombre: 'Mechas', categoria: CategoriaServicio.color, duracionMinutos: 90, precio: 40.0, publico: PublicoObjetivo.unisex),
    Servicio(id: 's11', nombre: 'Alisado', categoria: CategoriaServicio.tratamiento, duracionMinutos: 60, precio: 30.0, publico: PublicoObjetivo.unisex),
    Servicio(id: 's12', nombre: 'Peinado Básico', categoria: CategoriaServicio.peinado, duracionMinutos: 30, precio: 12.0, publico: PublicoObjetivo.unisex),
  ];

  static final List<Estilista> estilistas = [
    Estilista(id: 'e1', nombre: 'Carlos (Barbero)', rutaAvatar: 'assets/avatares/e1.png', serviciosQueRealiza: [servicios[3], servicios[4], servicios[5]]),
    Estilista(id: 'e2', nombre: 'Ana (Colorista)', rutaAvatar: 'assets/avatares/e2.png', serviciosQueRealiza: [servicios[0], servicios[1], servicios[2]]),
    Estilista(id: 'e3', nombre: 'Luis (Estilista)', rutaAvatar: 'assets/avatares/e3.png', serviciosQueRealiza: [servicios[0], servicios[3], servicios[6], servicios[7], servicios[11]]),
    Estilista(id: 'e4', nombre: 'María (Peinados)', rutaAvatar: 'assets/avatares/e4.png', serviciosQueRealiza: [servicios[2], servicios[7], servicios[10], servicios[11]]),
    Estilista(id: 'e5', nombre: 'Pedro (Todo Terreno)', rutaAvatar: 'assets/avatares/e5.png', serviciosQueRealiza: servicios),
  ];

  static final List<Cliente> clientes = [
    Cliente(id: 'c1', nombre: 'Laura Gómez', telefono: '55512345', genero: Genero.mujer, correo: 'laura@mail.com', fechaRegistro: DateTime.now().subtract(const Duration(days: 30))),
    Cliente(id: 'c2', nombre: 'Sofía Martínez', telefono: '55523456', genero: Genero.mujer, fechaRegistro: DateTime.now().subtract(const Duration(days: 20))),
    Cliente(id: 'c3', nombre: 'Carmen López', telefono: '55534567', genero: Genero.mujer, correo: 'carmen@mail.com', fechaRegistro: DateTime.now().subtract(const Duration(days: 15))),
    Cliente(id: 'c4', nombre: 'Elena Ruiz', telefono: '55545678', genero: Genero.mujer, fechaRegistro: DateTime.now().subtract(const Duration(days: 10))),
    Cliente(id: 'c5', nombre: 'Lucía Díaz', telefono: '55556789', genero: Genero.mujer, fechaRegistro: DateTime.now().subtract(const Duration(days: 5))),
    Cliente(id: 'c6', nombre: 'Juan Pérez', telefono: '55567890', genero: Genero.hombre, correo: 'juan@mail.com', fechaRegistro: DateTime.now().subtract(const Duration(days: 25))),
    Cliente(id: 'c7', nombre: 'Pedro Sánchez', telefono: '55578901', genero: Genero.hombre, fechaRegistro: DateTime.now().subtract(const Duration(days: 18))),
    Cliente(id: 'c8', nombre: 'Miguel Torres', telefono: '55589012', genero: Genero.hombre, fechaRegistro: DateTime.now().subtract(const Duration(days: 12))),
    Cliente(id: 'c9', nombre: 'David Flores', telefono: '55590123', genero: Genero.hombre, correo: 'david@mail.com', fechaRegistro: DateTime.now().subtract(const Duration(days: 7))),
    Cliente(id: 'c10', nombre: 'Andrés Ramírez', telefono: '55501234', genero: Genero.hombre, fechaRegistro: DateTime.now()),
  ];

  static final List<Turno> turnos = _generarTurnos();

  static List<Turno> _generarTurnos() {
    final hoy = DateTime.now();
    return [
      Turno(id: 't1', cliente: clientes[0], estilista: estilistas[1], servicios: [servicios[1], servicios[7]], fechaHoraInicio: hoy.subtract(const Duration(days: 2)).copyWith(hour: 10, minute: 0), estado: EstadoTurno.completado, fechaCreacion: hoy.subtract(const Duration(days: 5)), fechaModificacion: hoy.subtract(const Duration(days: 2))),
      Turno(id: 't2', cliente: clientes[5], estilista: estilistas[0], servicios: [servicios[3]], fechaHoraInicio: hoy.subtract(const Duration(days: 1)).copyWith(hour: 11, minute: 30), estado: EstadoTurno.completado, fechaCreacion: hoy.subtract(const Duration(days: 3)), fechaModificacion: hoy.subtract(const Duration(days: 1))),
      Turno(id: 't3', cliente: clientes[1], estilista: estilistas[2], servicios: [servicios[2]], fechaHoraInicio: hoy.subtract(const Duration(days: 1)).copyWith(hour: 15, minute: 0), estado: EstadoTurno.cancelado, fechaCreacion: hoy.subtract(const Duration(days: 2)), fechaModificacion: hoy.subtract(const Duration(days: 1))),
      Turno(id: 't4', cliente: clientes[1], estilista: estilistas[2], servicios: [servicios[0], servicios[6]], fechaHoraInicio: hoy.copyWith(hour: 9, minute: 0), estado: EstadoTurno.completado, fechaCreacion: hoy.subtract(const Duration(days: 2)), fechaModificacion: hoy.copyWith(hour: 9, minute: 45)),
      Turno(id: 't5', cliente: clientes[6], estilista: estilistas[0], servicios: [servicios[4], servicios[5]], fechaHoraInicio: hoy.copyWith(hour: 10, minute: 0), estado: EstadoTurno.programado, notas: 'Cliente prefiere máquina 1 a los lados.', fechaCreacion: hoy.subtract(const Duration(days: 1)), fechaModificacion: hoy.subtract(const Duration(days: 1))),
      Turno(id: 't6', cliente: clientes[2], estilista: estilistas[3], servicios: [servicios[8], servicios[11]], fechaHoraInicio: hoy.copyWith(hour: 14, minute: 0), estado: EstadoTurno.programado, fechaCreacion: hoy.subtract(const Duration(days: 1)), fechaModificacion: hoy.subtract(const Duration(days: 1))),
      Turno(id: 't7', cliente: clientes[7], estilista: estilistas[4], servicios: [servicios[6]], fechaHoraInicio: hoy.copyWith(hour: 16, minute: 0), estado: EstadoTurno.cancelado, fechaCreacion: hoy.subtract(const Duration(days: 2)), fechaModificacion: hoy),
      Turno(id: 't8', cliente: clientes[3], estilista: estilistas[1], servicios: [servicios[2]], fechaHoraInicio: hoy.add(const Duration(days: 1)).copyWith(hour: 10, minute: 0), estado: EstadoTurno.programado, fechaCreacion: hoy, fechaModificacion: hoy),
      Turno(id: 't9', cliente: clientes[8], estilista: estilistas[4], servicios: [servicios[9]], fechaHoraInicio: hoy.add(const Duration(days: 1)).copyWith(hour: 18, minute: 0), estado: EstadoTurno.programado, fechaCreacion: hoy, fechaModificacion: hoy),
      Turno(id: 't10', cliente: clientes[4], estilista: estilistas[3], servicios: [servicios[0], servicios[7], servicios[11]], fechaHoraInicio: hoy.add(const Duration(days: 2)).copyWith(hour: 11, minute: 0), estado: EstadoTurno.programado, fechaCreacion: hoy, fechaModificacion: hoy),
      Turno(id: 't11', cliente: clientes[6], estilista: estilistas[0], servicios: [servicios[3]], fechaHoraInicio: hoy.add(const Duration(days: 3)).copyWith(hour: 9, minute: 0), estado: EstadoTurno.programado, fechaCreacion: hoy, fechaModificacion: hoy),
      Turno(id: 't12', cliente: clientes[0], estilista: estilistas[1], servicios: [servicios[1]], fechaHoraInicio: hoy.add(const Duration(days: 3)).copyWith(hour: 15, minute: 0), estado: EstadoTurno.programado, notas: 'La clienta viene de un evento y necesita que el color quede perfecto. Tiene el cabello muy procesado, así que hay que aplicar un tratamiento suave antes. Se recomienda usar el tinte de la marca X en tono rubio cenizo. Por favor, reservar tiempo extra para el secado, ya que tiene mucho volumen.', fechaCreacion: hoy, fechaModificacion: hoy),
      Turno(id: 't13', cliente: clientes[2], estilista: estilistas[2], servicios: [servicios[6], servicios[7]], fechaHoraInicio: hoy.add(const Duration(days: 4)).copyWith(hour: 13, minute: 30), estado: EstadoTurno.programado, fechaCreacion: hoy, fechaModificacion: hoy),
      Turno(id: 't14', cliente: clientes[5], estilista: estilistas[2], servicios: [servicios[0]], fechaHoraInicio: hoy.add(const Duration(days: 5)).copyWith(hour: 10, minute: 0), estado: EstadoTurno.programado, fechaCreacion: hoy, fechaModificacion: hoy),
      Turno(id: 't15', cliente: clientes[7], estilista: estilistas[0], servicios: [servicios[5]], fechaHoraInicio: hoy.add(const Duration(days: 6)).copyWith(hour: 16, minute: 30), estado: EstadoTurno.programado, fechaCreacion: hoy, fechaModificacion: hoy),
      Turno(id: 't16', cliente: clientes[9], estilista: estilistas[3], servicios: [servicios[11]], fechaHoraInicio: hoy.add(const Duration(days: 7)).copyWith(hour: 9, minute: 30), estado: EstadoTurno.programado, fechaCreacion: hoy, fechaModificacion: hoy),
    ];
  }
}