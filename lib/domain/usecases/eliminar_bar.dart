import '../repositories/bar_repository.dart';

class EliminarBar {
  EliminarBar(this.repository);
  final BarRepository repository;
  Future<void> ejecutar(int id) => repository.eliminarBar(id);
}
