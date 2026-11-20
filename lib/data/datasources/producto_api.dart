import '../../domain/entities/producto.dart';
import '../models/producto_model.dart';
import 'cliente_api.dart';

class ProductoApi {
  ProductoApi(this.cliente);
  final ClienteApi cliente;

  Future<List<Producto>> obtenerProductos(int barId) async {
    final datos =
        await cliente.solicitar('GET', '/bares/$barId/productos') as List;
    return datos
        .map((dato) => ProductoModel.fromJson(dato as Map<String, dynamic>))
        .toList();
  }

  Future<Producto> crearProducto(Producto producto) async {
    final datos = await cliente.solicitar(
      'POST',
      '/bares/${producto.barId}/productos',
      {
        'nombre': producto.nombre,
        'precio': producto.precio,
        'categoria': producto.categoria,
        'disponible': producto.disponible,
      },
    );
    return ProductoModel.fromJson(datos as Map<String, dynamic>);
  }

  Future<Producto> actualizarProducto(Producto producto) async {
    final datos = await cliente.solicitar('PUT', '/productos/${producto.id}', {
      'nombre': producto.nombre,
      'precio': producto.precio,
      'categoria': producto.categoria,
      'disponible': producto.disponible,
    });
    return ProductoModel.fromJson(datos as Map<String, dynamic>);
  }

  Future<void> eliminarProducto(int id) async {
    await cliente.solicitar('DELETE', '/productos/$id');
  }
}
