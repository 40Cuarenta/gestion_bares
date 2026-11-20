class Inspeccion {
  const Inspeccion({
    this.id = 0,
    required this.barId,
    required this.fecha,
    required this.observacion,
    required this.resultado,
  });
  final int id;
  final int barId;
  final String fecha;
  final String observacion;
  final String resultado;

  static const resultados = [
    'Aprobado',
    'Aprobado con observaciones',
    'No aprobado',
  ];
}
