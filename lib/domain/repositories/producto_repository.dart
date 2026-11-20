import '../entities/producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> obtenerProductos(int barId);
  Future<Producto> crearProducto(Producto producto);
  Future<Producto> actualizarProducto(Producto producto);
  Future<void> eliminarProducto(int id);
}
