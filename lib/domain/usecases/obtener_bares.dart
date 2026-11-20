import '../entities/bar.dart';
import '../repositories/bar_repository.dart';

class ObtenerBares {
  ObtenerBares(this.repository);
  final BarRepository repository;
  Future<List<Bar>> ejecutar() => repository.obtenerBares();
}
