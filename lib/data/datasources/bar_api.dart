import '../../domain/entities/bar.dart';
import '../models/bar_model.dart';
import 'cliente_api.dart';

class BarApi {
  BarApi(this.cliente);
  final ClienteApi cliente;

  Future<List<Bar>> obtenerBares() async {
    final datos = await cliente.solicitar('GET', '/bares') as List;
    return datos
        .map((dato) => BarModel.fromJson(dato as Map<String, dynamic>))
        .toList();
  }

  Future<Bar> crearBar(Bar bar) async {
    final datos = await cliente.solicitar('POST', '/bares', {
      'nombre': bar.nombre,
      'ubicacion': bar.ubicacion,
      'responsable': bar.responsable,
    });
    return BarModel.fromJson(datos as Map<String, dynamic>);
  }

  Future<Bar> actualizarBar(Bar bar) async {
    final datos = await cliente.solicitar('PUT', '/bares/${bar.id}', {
      'nombre': bar.nombre,
      'ubicacion': bar.ubicacion,
      'responsable': bar.responsable,
    });
    return BarModel.fromJson(datos as Map<String, dynamic>);
  }

  Future<void> eliminarBar(int id) async {
    await cliente.solicitar('DELETE', '/bares/$id');
  }
}
