enum CategoriaServicio { corte, color, barba, peinado, tratamiento }
enum PublicoObjetivo { mujeres, hombres, unisex }

class Servicio {
  final String id;
  final String nombre;
  final CategoriaServicio categoria;
  final int duracionMinutos;
  final double precio;
  final PublicoObjetivo publico;

  Servicio({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.duracionMinutos,
    required this.precio,
    required this.publico,
  });
}