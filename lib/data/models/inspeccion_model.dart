import '../../domain/entities/inspeccion.dart';

class InspeccionModel extends Inspeccion {
  const InspeccionModel({
    super.id,
    required super.barId,
    required super.fecha,
    required super.observacion,
    required super.resultado,
  });

  factory InspeccionModel.fromJson(Map<String, dynamic> json) {
    return InspeccionModel(
      id: json['id'] as int,
      barId: json['barId'] as int,
      fecha: json['fecha'] as String,
      observacion: json['observacion'] as String,
      resultado: json['resultado'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'barId': barId,
    'fecha': fecha,
    'observacion': observacion,
    'resultado': resultado,
  };
}
