import 'package:flutter/foundation.dart';

import '../../domain/entities/bar.dart';
import '../../domain/usecases/obtener_bares.dart';
import '../../domain/usecases/crear_bar.dart';
import '../../domain/usecases/actualizar_bar.dart';
import '../../domain/usecases/eliminar_bar.dart';

class BarViewModel extends ChangeNotifier {
  BarViewModel(this.obtener, this.crear, this.actualizar, this.eliminar);
  final ObtenerBares obtener;
  final CrearBar crear;
  final ActualizarBar actualizar;
  final EliminarBar eliminar;
  List<Bar> bares = [];
  bool cargando = false;
  bool guardando = false;
  String error = '';
  int _solicitud = 0;

  Future<void> cargar() async {
    final solicitud = ++_solicitud;
    cargando = true;
    error = '';
    notifyListeners();
    try {
      final registros = await obtener.ejecutar();
      if (solicitud == _solicitud) bares = registros;
    } catch (excepcion) {
      if (solicitud == _solicitud) {
        bares = [];
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

  Future<bool> guardar(Bar bar) async {
    if (guardando) return false;
    guardando = true;
    error = '';
    notifyListeners();
    try {
      final guardado = await (bar.id == 0
          ? crear.ejecutar(bar)
          : actualizar.ejecutar(bar));
      bares.removeWhere((actual) => actual.id == guardado.id);
      bares.add(guardado);
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
      bares.removeWhere((actual) => actual.id == id);
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
