import '../../domain/entities/inspeccion.dart';
import '../../domain/repositories/inspeccion_repository.dart';
import '../datasources/inspeccion_api.dart';

class InspeccionRepositoryImpl implements InspeccionRepository {
  InspeccionRepositoryImpl(this.api);
  final InspeccionApi api;

  @override
  Future<List<Inspeccion>> obtenerInspecciones(int barId) =>
      api.obtenerInspecciones(barId);

  @override
  Future<Inspeccion> registrarInspeccion(Inspeccion inspeccion) =>
      api.registrarInspeccion(inspeccion);
}
