import '../entities/inspeccion.dart';
import '../repositories/inspeccion_repository.dart';

class RegistrarInspeccion {
  RegistrarInspeccion(this.repository);
  final InspeccionRepository repository;
  Future<Inspeccion> ejecutar(Inspeccion inspeccion) =>
      repository.registrarInspeccion(inspeccion);
}
