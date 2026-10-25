import 'servicio.dart';

class Estilista {
  final String id;
  final String nombre;
  final String rutaAvatar;
  final List<Servicio> serviciosQueRealiza;

  Estilista({
    required this.id,
    required this.nombre,
    required this.rutaAvatar,
    required this.serviciosQueRealiza,
  });
  
  bool realizaServicio(Servicio servicio) {
    return serviciosQueRealiza.any((s) => s.id == servicio.id);
  }
}