import '../../domain/entities/bar.dart';
import '../../domain/repositories/bar_repository.dart';
import '../datasources/bar_api.dart';

class BarRepositoryImpl implements BarRepository {
  BarRepositoryImpl(this.api);
  final BarApi api;

  @override
  Future<List<Bar>> obtenerBares() => api.obtenerBares();

  @override
  Future<Bar> crearBar(Bar bar) => api.crearBar(bar);

  @override
  Future<Bar> actualizarBar(Bar bar) => api.actualizarBar(bar);

  @override
  Future<void> eliminarBar(int id) => api.eliminarBar(id);
}
