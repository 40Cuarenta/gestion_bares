import '../../domain/entities/bar.dart';

class BarModel extends Bar {
  const BarModel({
    super.id,
    required super.nombre,
    required super.ubicacion,
    required super.responsable,
    super.habilitado,
  });

  factory BarModel.fromJson(Map<String, dynamic> json) {
    return BarModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      ubicacion: json['ubicacion'] as String,
      responsable: json['responsable'] as String,
      habilitado: json['habilitado'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'ubicacion': ubicacion,
    'responsable': responsable,
    'habilitado': habilitado,
  };
}
