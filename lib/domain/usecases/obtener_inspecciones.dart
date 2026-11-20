import '../entities/inspeccion.dart';
import '../repositories/inspeccion_repository.dart';

class ObtenerInspecciones {
  ObtenerInspecciones(this.repository);
  final InspeccionRepository repository;
  Future<List<Inspeccion>> ejecutar(int barId) =>
      repository.obtenerInspecciones(barId);
}
