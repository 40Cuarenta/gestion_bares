import 'package:flutter/material.dart';

import '../tema/tema_app.dart';
export 'superficie_vidrio.dart';

class Contenido extends StatelessWidget {
  const Contenido({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 860),
      child: child,
    ),
  );
}

class EtiquetaEstado extends StatelessWidget {
  const EtiquetaEstado({
    super.key,
    required this.texto,
    this.activo = true,
    this.conObservaciones = false,
  });
  final String texto;
  final bool activo;
  final bool conObservaciones;
  @override
  Widget build(BuildContext context) {
    final color = conObservaciones
        ? Colores.observacion
        : activo
        ? Colores.exito
        : Colores.textoPeligro;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              texto,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Aviso extends StatelessWidget {
  const Aviso({
    super.key,
    required this.mensaje,
    this.reintentar,
    this.esError = true,
  });
  final String mensaje;
  final VoidCallback? reintentar;
  final bool esError;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colores.superficie.withValues(alpha: .7),
      border: Border.all(
        color: (esError ? Colores.textoPeligro : Colores.observacion)
            .withValues(alpha: .3),
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mensaje,
          style: TextStyle(
            color: esError ? Colores.textoPeligro : Colores.texto,
          ),
        ),
        if (reintentar != null)
          TextButton.icon(
            onPressed: reintentar,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
      ],
    ),
  );
}

class EstadoVacio extends StatelessWidget {
  const EstadoVacio({
    super.key,
    required this.titulo,
    required this.descripcion,
    this.accion,
    this.etiqueta,
    this.icono = Icons.storefront_outlined,
  });
  final String titulo;
  final String descripcion;
  final VoidCallback? accion;
  final String? etiqueta;
  final IconData icono;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    child: Column(
      children: [
        Icon(icono, size: 36, color: Colores.secundario),
        const SizedBox(height: 20),
        Text(
          titulo,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(descripcion, textAlign: TextAlign.center),
        if (accion != null) ...[
          const SizedBox(height: 24),
          FilledButton(onPressed: accion, child: Text(etiqueta!)),
        ],
      ],
    ),
  );
}

class EncabezadoFormulario extends StatelessWidget {
  const EncabezadoFormulario({
    super.key,
    required this.titulo,
    required this.descripcion,
  });
  final String titulo;
  final String descripcion;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(titulo, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 10),
      Text(descripcion),
      const SizedBox(height: 28),
    ],
  );
}

Future<bool> confirmarEliminacion(BuildContext context, String mensaje) async {
  return await showDialog<bool>(
        context: context,
        builder: (contexto) => AlertDialog(
          title: const Text('¿Eliminar registro?'),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contexto, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(contexto, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colores.peligro,
                foregroundColor: Colores.fondo,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ) ??
      false;
}

void mostrarMensaje(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
}

String mostrarFecha(String fecha) {
  final partes = fecha.split('-');
  return partes.length == 3 ? '${partes[2]}/${partes[1]}/${partes[0]}' : fecha;
}
