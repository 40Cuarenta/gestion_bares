import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class ObtenerProductos {
  ObtenerProductos(this.repository);
  final ProductoRepository repository;
  Future<List<Producto>> ejecutar(int barId) =>
      repository.obtenerProductos(barId);
}
