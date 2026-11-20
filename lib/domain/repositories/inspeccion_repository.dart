import '../entities/inspeccion.dart';

abstract class InspeccionRepository {
  Future<List<Inspeccion>> obtenerInspecciones(int barId);
  Future<Inspeccion> registrarInspeccion(Inspeccion inspeccion);
}
