import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/bar.dart';
import '../../routes/app_routes.dart';
import '../tema/tema_app.dart';
import '../viewmodels/bar_viewmodel.dart';
import '../widgets/componentes.dart';

class BaresView extends StatefulWidget {
  const BaresView({super.key});
  @override
  State<BaresView> createState() => _EstadoBaresView();
}

class _EstadoBaresView extends State<BaresView> {
  String busqueda = '';
  String filtro = 'Todos';
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<BarViewModel>().cargar();
    });
  }

  Future<void> eliminar(Bar bar) async {
    bool confirmar = await confirmarEliminacion(
      context,
      'Se eliminará ${bar.nombre} y sus productos. Si tiene inspecciones, la eliminación será rechazada para conservar el historial.',
    );
    if (!confirmar || !mounted) return;
    final modelo = context.read<BarViewModel>();
    bool eliminado = await modelo.borrar(bar.id);
    if (mounted) {
      mostrarMensaje(context, eliminado ? 'Bar eliminado.' : modelo.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<BarViewModel>();
    final bares = modelo.bares
        .where(
          (bar) =>
              '${bar.nombre} ${bar.ubicacion} ${bar.responsable}'
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().trim()) &&
              (filtro == 'Todos' ||
                  (filtro == 'Habilitados' ? bar.habilitado : !bar.habilitado)),
        )
        .toList();
    return Scaffold(
      appBar: BarraVidrio(
        title: const Text('Los bares del campus'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: modelo.cargando ? null : modelo.cargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: modelo.guardando
            ? null
            : () => Navigator.pushNamed(context, AppRoutes.formularioBar),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo bar'),
      ),
      body: SafeArea(
        child: Contenido(
          child: RefreshIndicator(
            onRefresh: modelo.cargar,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 110),
              children: [
                Text(
                  'Administrar bares',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Consulta, filtra y administra los puntos de venta.',
                ),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (texto) => setState(() => busqueda = texto),
                  decoration: const InputDecoration(
                    labelText: 'Buscar bar o ubicación',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: ['Todos', 'Habilitados', 'Inhabilitados']
                      .map(
                        (opcion) => ChoiceChip(
                          label: Text(opcion),
                          selected: filtro == opcion,
                          onSelected: (_) => setState(() => filtro = opcion),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                if (modelo.cargando)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  if (modelo.error.isNotEmpty)
                    Aviso(mensaje: modelo.error, reintentar: modelo.cargar),
                  if (bares.isEmpty && modelo.error.isEmpty)
                    EstadoVacio(
                      titulo: modelo.bares.isEmpty
                          ? 'Sin bares registrados'
                          : 'Sin coincidencias',
                      descripcion: modelo.bares.isEmpty
                          ? 'Registra el primer bar para gestionar sus productos e inspecciones.'
                          : 'Prueba otro nombre o cambia el filtro.',
                      accion: modelo.bares.isEmpty
                          ? () => Navigator.pushNamed(
                              context,
                              AppRoutes.formularioBar,
                            )
                          : null,
                      etiqueta: 'Registrar primer bar',
                    ),
                  ...bares.map(
                    (bar) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TarjetaVidrio(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.detalleBar,
                                arguments: bar,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    EtiquetaEstado(
                                      texto: bar.habilitado
                                          ? 'Habilitado'
                                          : 'Inhabilitado',
                                      activo: bar.habilitado,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      bar.nombre,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(bar.ubicacion),
                                    const SizedBox(height: 4),
                                    Text('Responsable: ${bar.responsable}'),
                                    const SizedBox(height: 16),
                                    const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Ver productos e inspecciones',
                                            style: TextStyle(
                                              color: Colores.primario,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 18,
                                          color: Colores.primario,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Wrap(
                                spacing: 12,
                                children: [
                                  TextButton.icon(
                                    onPressed: modelo.guardando
                                        ? null
                                        : () => Navigator.pushNamed(
                                            context,
                                            AppRoutes.formularioBar,
                                            arguments: bar,
                                          ),
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 19,
                                    ),
                                    label: const Text('Editar'),
                                  ),
                                  TextButton.icon(
                                    onPressed: modelo.guardando
                                        ? null
                                        : () => eliminar(bar),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 19,
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colores.textoPeligro,
                                    ),
                                    label: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
