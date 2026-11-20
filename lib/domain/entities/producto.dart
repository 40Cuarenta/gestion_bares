class Producto {
  const Producto({
    this.id = 0,
    required this.barId,
    required this.nombre,
    required this.precio,
    required this.categoria,
    this.disponible = true,
  });
  final int id;
  final int barId;
  final String nombre;
  final double precio;
  final String categoria;
  final bool disponible;
}
