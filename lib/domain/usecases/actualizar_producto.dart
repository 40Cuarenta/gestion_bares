import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class ActualizarProducto {
  ActualizarProducto(this.repository);
  final ProductoRepository repository;
  Future<Producto> ejecutar(Producto producto) =>
      repository.actualizarProducto(producto);
}
