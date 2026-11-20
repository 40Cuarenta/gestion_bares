import 'package:flutter/foundation.dart';

import '../../domain/entities/producto.dart';
import '../../domain/usecases/obtener_productos.dart';
import '../../domain/usecases/crear_producto.dart';
import '../../domain/usecases/actualizar_producto.dart';
import '../../domain/usecases/eliminar_producto.dart';

class ProductoViewModel extends ChangeNotifier {
  ProductoViewModel(this.obtener, this.crear, this.actualizar, this.eliminar);
  final ObtenerProductos obtener;
  final CrearProducto crear;
  final ActualizarProducto actualizar;
  final EliminarProducto eliminar;
  List<Producto> productos = [];
  bool cargando = false;
  bool guardando = false;
  String error = '';
  int _solicitud = 0;

  Future<void> cargar(int barId) async {
    final solicitud = ++_solicitud;
    cargando = true;
    error = '';
    notifyListeners();
    try {
      final registros = await obtener.ejecutar(barId);
      if (solicitud == _solicitud) productos = registros;
    } catch (excepcion) {
      if (solicitud == _solicitud) {
        productos = [];
        error = excepcion.toString();
      }
    } finally {
      if (solicitud == _solicitud) {
        cargando = false;
        notifyListeners();
      }
    }
  }

  void limpiarError() {
    error = '';
    notifyListeners();
  }

  Future<bool> guardar(Producto producto) async {
    if (guardando) return false;
    guardando = true;
    error = '';
    notifyListeners();
    try {
      final guardado = await (producto.id == 0
          ? crear.ejecutar(producto)
          : actualizar.ejecutar(producto));
      productos.removeWhere((actual) => actual.id == guardado.id);
      productos.add(guardado);
      return true;
    } catch (excepcion) {
      error = excepcion.toString();
      return false;
    } finally {
      guardando = false;
      notifyListeners();
    }
  }

  Future<bool> borrar(int id) async {
    if (guardando) return false;
    guardando = true;
    error = '';
    notifyListeners();
    try {
      await eliminar.ejecutar(id);
      productos.removeWhere((actual) => actual.id == id);
      return true;
    } catch (excepcion) {
      error = excepcion.toString();
      return false;
    } finally {
      guardando = false;
      notifyListeners();
    }
  }
}
