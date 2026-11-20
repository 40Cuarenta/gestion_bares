import '../entities/bar.dart';
import '../repositories/bar_repository.dart';

class CrearBar {
  CrearBar(this.repository);
  final BarRepository repository;
  Future<Bar> ejecutar(Bar bar) => repository.crearBar(bar);
}
