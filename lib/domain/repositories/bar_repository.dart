import '../entities/bar.dart';

abstract class BarRepository {
  Future<List<Bar>> obtenerBares();
  Future<Bar> crearBar(Bar bar);
  Future<Bar> actualizarBar(Bar bar);
  Future<void> eliminarBar(int id);
}
