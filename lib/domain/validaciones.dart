// Validaciones compartidas por la aplicación y el servidor, sin widgets.
class Validaciones {
  static String? texto(String? valor, String campo, {int maximo = 100}) {
    String limpio = (valor ?? '').trim();
    if (limpio.isEmpty) return 'Ingrese $campo.';
    if (limpio.length > maximo) return 'Use hasta $maximo caracteres.';
    if (!RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ0-9]').hasMatch(limpio)) {
      return 'Ingrese un texto válido para $campo.';
    }
    return null;
  }

  static String? responsable(String? valor) {
    String? error = texto(valor, 'el responsable');
    if (error != null) return error;
    if (!RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]').hasMatch(valor!)) {
      return 'El responsable debe incluir un nombre.';
    }
    return null;
  }

  static String? precio(String? valor) {
    String limpio = (valor ?? '').trim().replaceAll(',', '.');
    if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(limpio)) {
      return 'Ingrese un precio positivo con hasta 2 decimales.';
    }
    double? numero = double.tryParse(limpio);
    if (numero == null || !numero.isFinite || numero <= 0) {
      return 'El precio debe ser mayor que cero.';
    }
    return null;
  }

  static String? fecha(String? valor) {
    if (valor == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(valor)) {
      return 'Seleccione una fecha válida.';
    }
    DateTime? fecha = DateTime.tryParse(valor);
    if (fecha == null || fecha.toIso8601String().substring(0, 10) != valor) {
      return 'La fecha no existe.';
    }
    if (fecha.isAfter(DateTime.now())) return 'La fecha no puede ser futura.';
    return null;
  }
}
