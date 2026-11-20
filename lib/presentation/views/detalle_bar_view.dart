import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/bar.dart';
import '../../domain/entities/producto.dart';
import '../../routes/app_routes.dart';
import '../tema/tema_app.dart';
import '../viewmodels/bar_viewmodel.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../viewmodels/inspeccion_viewmodel.dart';
import '../widgets/componentes.dart';

class DetalleBarView extends StatefulWidget {
  const DetalleBarView({super.key});
  @override
  State<DetalleBarView> createState() => _EstadoDetalleBarView();
}

class _EstadoDetalleBarView extends State<DetalleBarView> {
  Bar? barInicial;
  bool iniciado = false;
  bool cargando = true;
  int seccion = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (iniciado) return;
    iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    if (argumento is Bar) barInicial = argumento;
    Future.microtask(recargar);
  }

  Future<void> recargar() async {
    if (!mounted || barInicial == null) return;
    setState(() => cargando = true);
    await Future.wait([
      context.read<BarViewModel>().cargar(),
      context.read<ProductoViewModel>().cargar(barInicial!.id),
      context.read<InspeccionViewModel>().cargar(barInicial!.id),
    ]);
    if (mounted) setState(() => cargando = false);
  }

  Future<void> abrirFormulario(String ruta, Object argumento) async {
    final guardado = await Navigator.pushNamed(
      context,
      ruta,
      arguments: argumento,
    );
    if (guardado == true && mounted) await recargar();
  }

  Future<void> eliminarProducto(Producto producto) async {
    final confirmado = await confirmarEliminacion(
      context,
      'Se eliminará el producto ${producto.nombre}.',
    );
    if (!confirmado || !mounted) return;
    final modelo = context.read<ProductoViewModel>();
    final correcto = await modelo.borrar(producto.id);
    if (mounted) {
      mostrarMensaje(context, correcto ? 'Producto eliminado.' : modelo.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bares = context.watch<BarViewModel>();
    final productos = context.watch<ProductoViewModel>();
    final inspecciones = context.watch<InspeccionViewModel>();
    Bar? bar;
    for (final registro in bares.bares) {
      if (registro.id == barInicial?.id) bar = registro;
    }
    if (barInicial == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(child: Text('Abra un bar desde la lista.')),
        ),
      );
    }
    final actual = bar;
    return Scaffold(
      appBar: BarraVidrio(
        title: const Text('Detalle del bar'),
        actions: [
          IconButton(
            tooltip: 'Actualizar información',
            onPressed: cargando ? null : recargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Contenido(
          child: RefreshIndicator(
            onRefresh: recargar,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                if (cargando)
                  const Padding(
                    padding: EdgeInsets.all(60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (bares.error.isNotEmpty)
                  Aviso(mensaje: bares.error, reintentar: recargar)
                else if (actual == null)
                  const EstadoVacio(
                    titulo: 'Este bar ya no está disponible',
                    descripcion:
                        'Vuelve a la lista para consultar otros espacios.',
                  )
                else ...[
                  Text(
                    actual.nombre,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      EtiquetaEstado(
                        texto: actual.habilitado
                            ? 'Bar habilitado'
                            : 'Bar inhabilitado',
                        activo: actual.habilitado,
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            abrirFormulario(AppRoutes.formularioBar, actual),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Editar datos'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(actual.ubicacion),
                  Text('Responsable: ${actual.responsable}'),
                  const SizedBox(height: 20),
                  if (!actual.habilitado)
                    const Aviso(
                      mensaje: 'Este bar está inhabilitado. Sus productos no están disponibles para la venta y no se pueden agregar nuevos. Una nueva inspección aprobada o aprobada con observaciones puede rehabilitarlo.',
                      esError: false,
                    ),
                  const Divider(),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(
                          'Productos (${productos.productos.length})',
                        ),
                        selected: seccion == 0,
                        onSelected: (_) => setState(() => seccion = 0),
                      ),
                      ChoiceChip(
                        label: Text(
                          'Inspecciones (${inspecciones.inspecciones.length})',
                        ),
                        selected: seccion == 1,
                        onSelected: (_) => setState(() => seccion = 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (seccion == 0) ...[
                    Text(
                      'Productos del bar',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Productos, precios y disponibilidad a la vista.',
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: !actual.habilitado || productos.guardando
                          ? null
                          : () => abrirFormulario(
                              AppRoutes.formularioProducto,
                              actual,
                            ),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar producto'),
                    ),
                    const SizedBox(height: 20),
                    if (productos.error.isNotEmpty)
                      Aviso(mensaje: productos.error, reintentar: recargar),
                    if (productos.productos.isEmpty && productos.error.isEmpty)
                      const EstadoVacio(
                        titulo: 'Sin productos registrados',
                        descripcion:
                            'Los productos de este bar aparecerán aquí.',
                        icono: Icons.restaurant_menu_outlined,
                      ),
                    ...productos.productos.map(
                      (producto) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: TarjetaVidrio(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            producto.nombre,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Text(producto.categoria),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '\$${producto.precio.toStringAsFixed(2)}',
                                    style: Estilos.precio,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                EtiquetaEstado(
                                  texto: !actual.habilitado
                                      ? 'No disponible · bar inhabilitado'
                                      : producto.disponible
                                      ? 'Disponible para la venta'
                                      : 'No disponible',
                                  activo:
                                      actual.habilitado && producto.disponible,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 12,
                                  children: [
                                    TextButton.icon(
                                      onPressed: productos.guardando
                                          ? null
                                          : () => abrirFormulario(
                                              AppRoutes.formularioProducto,
                                              producto,
                                            ),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                      ),
                                      label: const Text('Editar'),
                                    ),
                                    TextButton.icon(
                                      onPressed: productos.guardando
                                          ? null
                                          : () => eliminarProducto(producto),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colores.textoPeligro,
                                      ),
                                      label: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Inspecciones del bar',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('Un historial que respalda cada espacio.'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => abrirFormulario(
                        AppRoutes.formularioInspeccion,
                        actual,
                      ),
                      icon: const Icon(Icons.fact_check_outlined),
                      label: const Text('Registrar inspección'),
                    ),
                    const SizedBox(height: 20),
                    if (inspecciones.error.isNotEmpty)
                      Aviso(mensaje: inspecciones.error, reintentar: recargar),
                    if (inspecciones.inspecciones.isEmpty &&
                        inspecciones.error.isEmpty)
                      const EstadoVacio(
                        titulo: 'Sin inspecciones registradas',
                        descripcion: 'Registra la primera revisión de higiene y funcionamiento.',
                        icono: Icons.fact_check_outlined,
                      ),
                    ...inspecciones.inspecciones.map(
                      (inspeccion) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: TarjetaVidrio(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.event_outlined,
                                      color: Colores.primario,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      mostrarFecha(inspeccion.fecha),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                EtiquetaEstado(
                                  texto: inspeccion.resultado,
                                  activo: inspeccion.resultado != 'No aprobado',
                                  conObservaciones:
                                      inspeccion.resultado ==
                                      'Aprobado con observaciones',
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  inspeccion.observacion,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'El historial se conserva: las inspecciones no se editan ni eliminan. La más reciente por fecha determina la habilitación.',
                    ),
                  ],
                  const SizedBox(height: 28),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
