import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ErrorApi implements Exception {
  ErrorApi(this.mensaje);
  final String mensaje;
  @override
  String toString() => mensaje;
}

class ClienteApi {
  ClienteApi({
    String? direccion,
    http.Client? cliente,
    this.usarMockSiFalla = true,
  })  : direccion = direccion ??
            const String.fromEnvironment(
              'API_URL',
              defaultValue: kIsWeb
                  ? 'http://localhost:8080'
                  : 'http://10.0.2.2:8080',
            ),
        cliente = cliente ?? http.Client();

  final String direccion;
  final http.Client cliente;
  final bool usarMockSiFalla;
  bool _modoSimuladoActivo = false;

  bool get esModoSimulado => _modoSimuladoActivo;

  // --- Almacén en memoria para modo simulado / local ---
  static int _nextBarId = 4;
  static int _nextProductoId = 10;
  static int _nextInspeccionId = 4;

  static final List<Map<String, dynamic>> _mockBares = [
    {
      'id': 1,
      'nombre': 'Bar Central - Bloque A',
      'ubicacion': 'Edificio Central, planta baja',
      'responsable': 'Carlos Mendoza',
      'habilitado': true,
    },
    {
      'id': 2,
      'nombre': 'Cafetería Las Palmas',
      'ubicacion': 'Frente a Biblioteca General',
      'responsable': 'María Eugenia Torres',
      'habilitado': true,
    },
    {
      'id': 3,
      'nombre': 'Snack & Coffee Bloque F',
      'ubicacion': 'Facultad de Ingeniería, primer piso',
      'responsable': 'Roberto Gómez',
      'habilitado': false,
    },
  ];

  static final List<Map<String, dynamic>> _mockProductos = [
    // Productos Bar 1
    {
      'id': 1,
      'barId': 1,
      'nombre': 'Almuerzo Ejecutivo',
      'precio': 3.25,
      'categoria': 'Almuerzos',
      'disponible': true,
    },
    {
      'id': 2,
      'barId': 1,
      'nombre': 'Empanada de verde con queso',
      'precio': 1.00,
      'categoria': 'Snacks',
      'disponible': true,
    },
    {
      'id': 3,
      'barId': 1,
      'nombre': 'Café pasado tradicional',
      'precio': 0.75,
      'categoria': 'Bebidas',
      'disponible': true,
    },
    {
      'id': 4,
      'barId': 1,
      'nombre': 'Jugo natural de mora',
      'precio': 1.25,
      'categoria': 'Bebidas',
      'disponible': true,
    },
    // Productos Bar 2
    {
      'id': 5,
      'barId': 2,
      'nombre': 'Sandwich mixto caliente',
      'precio': 1.75,
      'categoria': 'Desayunos',
      'disponible': true,
    },
    {
      'id': 6,
      'barId': 2,
      'nombre': 'Capuchino artesanal',
      'precio': 1.50,
      'categoria': 'Bebidas',
      'disponible': true,
    },
    {
      'id': 7,
      'barId': 2,
      'nombre': 'Muffin de arándanos',
      'precio': 1.20,
      'categoria': 'Pastelería',
      'disponible': true,
    },
    // Productos Bar 3 (Bar inhabilitado)
    {
      'id': 8,
      'barId': 3,
      'nombre': 'Tarrina de frutas frescas',
      'precio': 1.50,
      'categoria': 'Snacks',
      'disponible': false,
    },
    {
      'id': 9,
      'barId': 3,
      'nombre': 'Botella de agua 600ml',
      'precio': 0.60,
      'categoria': 'Bebidas',
      'disponible': false,
    },
  ];

  static final List<Map<String, dynamic>> _mockInspecciones = [
    {
      'id': 1,
      'barId': 1,
      'fecha': '2026-11-15',
      'observacion':
          'Instalaciones limpias, manipulación adecuada de alimentos y refrigeración en óptimas temperaturas.',
      'resultado': 'Aprobado',
    },
    {
      'id': 2,
      'barId': 2,
      'fecha': '2026-11-10',
      'observacion':
          'Higiene general adecuada. Se solicita renovar extintor de cocina en los próximos 15 días.',
      'resultado': 'Aprobado con observaciones',
    },
    {
      'id': 3,
      'barId': 3,
      'fecha': '2026-11-18',
      'observacion':
          'Problemas en el sistema de refrigeración y falta de carnet sanitario vigente del personal.',
      'resultado': 'No aprobado',
    },
  ];

  Future<dynamic> solicitar(
    String metodo,
    String ruta, [
    Map<String, dynamic>? datos,
  ]) async {
    // Si ya se detectó que no hay backend activo, responder directamente con mock
    if (_modoSimuladoActivo && usarMockSiFalla) {
      return _responderMock(metodo, ruta, datos);
    }

    try {
      final peticion = http.Request(metodo, Uri.parse('$direccion$ruta'));
      peticion.headers['Content-Type'] = 'application/json; charset=utf-8';
      if (datos != null) peticion.body = jsonEncode(datos);

      final respuesta = await http.Response.fromStream(
        await cliente.send(peticion).timeout(const Duration(seconds: 4)),
      ).timeout(const Duration(seconds: 4));

      dynamic contenido = respuesta.body.isEmpty
          ? null
          : jsonDecode(utf8.decode(respuesta.bodyBytes));

      if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
        throw ErrorApi(
          contenido is Map
              ? contenido['error']?.toString() ?? 'Error del servidor.'
              : 'Error del servidor.',
        );
      }
      return contenido;
    } on ErrorApi {
      rethrow;
    } on TimeoutException {
      if (usarMockSiFalla) {
        _modoSimuladoActivo = true;
        debugPrint(
            '⚠️ API no respondió a tiempo en $direccion. Activando modo local simulado.');
        return _responderMock(metodo, ruta, datos);
      }
      throw ErrorApi('La API tardó demasiado. Intente nuevamente.');
    } on FormatException {
      if (usarMockSiFalla) {
        _modoSimuladoActivo = true;
        debugPrint(
            '⚠️ Respuesta inválida de la API. Activando modo local simulado.');
        return _responderMock(metodo, ruta, datos);
      }
      throw ErrorApi('La API devolvió una respuesta inválida.');
    } on http.ClientException {
      if (usarMockSiFalla) {
        _modoSimuladoActivo = true;
        debugPrint(
            'ℹ️ Backend no detectado en $direccion. Activando modo local simulado.');
        return _responderMock(metodo, ruta, datos);
      }
      throw ErrorApi(
        'No se pudo conectar. Compruebe que la API esté encendida.',
      );
    } catch (_) {
      if (usarMockSiFalla) {
        _modoSimuladoActivo = true;
        return _responderMock(metodo, ruta, datos);
      }
      rethrow;
    }
  }

  Future<dynamic> _responderMock(
    String metodo,
    String ruta, [
    Map<String, dynamic>? datos,
  ]) async {
    // Simulación de pequeña latencia natural (120ms)
    await Future.delayed(const Duration(milliseconds: 120));

    // /bares
    if (ruta == '/bares') {
      if (metodo == 'GET') {
        return List<Map<String, dynamic>>.from(
          _mockBares.map((b) => Map<String, dynamic>.from(b)),
        );
      }
      if (metodo == 'POST') {
        final nuevo = {
          'id': _nextBarId++,
          'nombre': datos?['nombre'] ?? '',
          'ubicacion': datos?['ubicacion'] ?? '',
          'responsable': datos?['responsable'] ?? '',
          'habilitado': true,
        };
        _mockBares.add(nuevo);
        return Map<String, dynamic>.from(nuevo);
      }
    }

    // /bares/:id
    final matchBarId = RegExp(r'^/bares/(\d+)$').firstMatch(ruta);
    if (matchBarId != null) {
      final id = int.parse(matchBarId.group(1)!);
      if (metodo == 'PUT') {
        final index = _mockBares.indexWhere((b) => b['id'] == id);
        if (index == -1) throw ErrorApi('Bar no encontrado.');
        final actual = _mockBares[index];
        final actualizado = {
          'id': id,
          'nombre': datos?['nombre'] ?? actual['nombre'],
          'ubicacion': datos?['ubicacion'] ?? actual['ubicacion'],
          'responsable': datos?['responsable'] ?? actual['responsable'],
          'habilitado': actual['habilitado'],
        };
        _mockBares[index] = actualizado;
        return Map<String, dynamic>.from(actualizado);
      }
      if (metodo == 'DELETE') {
        final tieneInspecciones =
            _mockInspecciones.any((i) => i['barId'] == id);
        if (tieneInspecciones) {
          throw ErrorApi(
            'No se puede eliminar el bar porque conserva un historial de inspecciones.',
          );
        }
        _mockBares.removeWhere((b) => b['id'] == id);
        _mockProductos.removeWhere((p) => p['barId'] == id);
        return {'mensaje': 'Bar eliminado correctamente.'};
      }
    }

    // /bares/:barId/productos
    final matchBarProductos =
        RegExp(r'^/bares/(\d+)/productos$').firstMatch(ruta);
    if (matchBarProductos != null) {
      final barId = int.parse(matchBarProductos.group(1)!);
      if (metodo == 'GET') {
        final filtrados =
            _mockProductos.where((p) => p['barId'] == barId).toList();
        return List<Map<String, dynamic>>.from(
          filtrados.map((p) => Map<String, dynamic>.from(p)),
        );
      }
      if (metodo == 'POST') {
        final nuevo = {
          'id': _nextProductoId++,
          'barId': barId,
          'nombre': datos?['nombre'] ?? '',
          'precio': (datos?['precio'] as num?)?.toDouble() ?? 0.0,
          'categoria': datos?['categoria'] ?? '',
          'disponible': datos?['disponible'] ?? true,
        };
        _mockProductos.add(nuevo);
        return Map<String, dynamic>.from(nuevo);
      }
    }

    // /productos/:id
    final matchProductoId = RegExp(r'^/productos/(\d+)$').firstMatch(ruta);
    if (matchProductoId != null) {
      final id = int.parse(matchProductoId.group(1)!);
      if (metodo == 'PUT') {
        final index = _mockProductos.indexWhere((p) => p['id'] == id);
        if (index == -1) throw ErrorApi('Producto no encontrado.');
        final actual = _mockProductos[index];
        final actualizado = {
          'id': id,
          'barId': actual['barId'],
          'nombre': datos?['nombre'] ?? actual['nombre'],
          'precio':
              (datos?['precio'] as num?)?.toDouble() ?? actual['precio'],
          'categoria': datos?['categoria'] ?? actual['categoria'],
          'disponible': datos?['disponible'] ?? actual['disponible'],
        };
        _mockProductos[index] = actualizado;
        return Map<String, dynamic>.from(actualizado);
      }
      if (metodo == 'DELETE') {
        _mockProductos.removeWhere((p) => p['id'] == id);
        return {'mensaje': 'Producto eliminado correctamente.'};
      }
    }

    // /bares/:barId/inspecciones
    final matchBarInspecciones =
        RegExp(r'^/bares/(\d+)/inspecciones$').firstMatch(ruta);
    if (matchBarInspecciones != null) {
      final barId = int.parse(matchBarInspecciones.group(1)!);
      if (metodo == 'GET') {
        final filtradas =
            _mockInspecciones.where((i) => i['barId'] == barId).toList();
        return List<Map<String, dynamic>>.from(
          filtradas.map((i) => Map<String, dynamic>.from(i)),
        );
      }
      if (metodo == 'POST') {
        final nuevo = {
          'id': _nextInspeccionId++,
          'barId': barId,
          'fecha': datos?['fecha'] ?? '',
          'observacion': datos?['observacion'] ?? '',
          'resultado': datos?['resultado'] ?? 'Aprobado',
        };
        _mockInspecciones.insert(0, nuevo);

        // Actualizar automáticamente la habilitación del bar
        final indexBar = _mockBares.indexWhere((b) => b['id'] == barId);
        if (indexBar != -1) {
          final habilitado = nuevo['resultado'] != 'No aprobado';
          _mockBares[indexBar]['habilitado'] = habilitado;
        }

        return Map<String, dynamic>.from(nuevo);
      }
    }

    throw ErrorApi('Ruta no encontrada en la API simulada: $ruta');
  }

  void cerrar() => cliente.close();
}
