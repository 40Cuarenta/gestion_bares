import '../../domain/entities/producto.dart';

class ProductoModel extends Producto {
  const ProductoModel({
    super.id,
    required super.barId,
    required super.nombre,
    required super.precio,
    required super.categoria,
    super.disponible,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json['id'] as int,
      barId: json['barId'] as int,
      nombre: json['nombre'] as String,
      precio: (json['precio'] as num).toDouble(),
      categoria: json['categoria'] as String,
      disponible: json['disponible'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'barId': barId,
    'nombre': nombre,
    'precio': precio,
    'categoria': categoria,
    'disponible': disponible,
  };
}
