import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class CrearProducto {
  CrearProducto(this.repository);
  final ProductoRepository repository;
  Future<Producto> ejecutar(Producto producto) =>
      repository.crearProducto(producto);
}
