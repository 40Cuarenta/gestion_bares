import '../entities/bar.dart';
import '../repositories/bar_repository.dart';

class ActualizarBar {
  ActualizarBar(this.repository);
  final BarRepository repository;
  Future<Bar> ejecutar(Bar bar) => repository.actualizarBar(bar);
}
