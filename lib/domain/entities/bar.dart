class Bar {
  const Bar({
    this.id = 0,
    required this.nombre,
    required this.ubicacion,
    required this.responsable,
    this.habilitado = true,
  });
  final int id;
  final String nombre;
  final String ubicacion;
  final String responsable;
  final bool habilitado;
}
