import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/producto_api.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  ProductoRepositoryImpl(this.api);
  final ProductoApi api;

  @override
  Future<List<Producto>> obtenerProductos(int barId) =>
      api.obtenerProductos(barId);

  @override
  Future<Producto> crearProducto(Producto producto) =>
      api.crearProducto(producto);

  @override
  Future<Producto> actualizarProducto(Producto producto) =>
      api.actualizarProducto(producto);

  @override
  Future<void> eliminarProducto(int id) => api.eliminarProducto(id);
}
