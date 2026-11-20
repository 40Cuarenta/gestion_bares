import 'package:flutter/foundation.dart';

import '../../domain/entities/inspeccion.dart';
import '../../domain/usecases/obtener_inspecciones.dart';
import '../../domain/usecases/registrar_inspeccion.dart';

class InspeccionViewModel extends ChangeNotifier {
  InspeccionViewModel(this.obtener, this.registrar);
  final ObtenerInspecciones obtener;
  final RegistrarInspeccion registrar;
  List<Inspeccion> inspecciones = [];
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
      if (solicitud == _solicitud) inspecciones = registros;
    } catch (excepcion) {
      if (solicitud == _solicitud) {
        inspecciones = [];
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

  Future<bool> guardar(Inspeccion inspeccion) async {
    if (guardando) return false;
    guardando = true;
    error = '';
    notifyListeners();
    try {
      final nueva = await registrar.ejecutar(inspeccion);
      inspecciones.insert(0, nueva);
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
