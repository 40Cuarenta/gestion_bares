import '../../domain/entities/inspeccion.dart';
import '../models/inspeccion_model.dart';
import 'cliente_api.dart';

class InspeccionApi {
  InspeccionApi(this.cliente);
  final ClienteApi cliente;

  Future<List<Inspeccion>> obtenerInspecciones(int barId) async {
    final datos =
        await cliente.solicitar('GET', '/bares/$barId/inspecciones') as List;
    return datos
        .map((dato) => InspeccionModel.fromJson(dato as Map<String, dynamic>))
        .toList();
  }

  Future<Inspeccion> registrarInspeccion(Inspeccion inspeccion) async {
    final datos = await cliente.solicitar(
      'POST',
      '/bares/${inspeccion.barId}/inspecciones',
      {
        'fecha': inspeccion.fecha,
        'observacion': inspeccion.observacion,
        'resultado': inspeccion.resultado,
      },
    );
    return InspeccionModel.fromJson(datos as Map<String, dynamic>);
  }
}
