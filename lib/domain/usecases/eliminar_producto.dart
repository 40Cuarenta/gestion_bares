import '../repositories/producto_repository.dart';

class EliminarProducto {
  EliminarProducto(this.repository);
  final ProductoRepository repository;
  Future<void> ejecutar(int id) => repository.eliminarProducto(id);
}
