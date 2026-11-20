import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../routes/app_routes.dart';
import '../viewmodels/bar_viewmodel.dart';
import '../tema/tema_app.dart';
import '../widgets/componentes.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});
  @override
  State<InicioView> createState() => _EstadoInicioView();
}

class _EstadoInicioView extends State<InicioView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<BarViewModel>().cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<BarViewModel>();
    final activos = modelo.bares.where((bar) => bar.habilitado).length;
    final inactivos = modelo.bares.length - activos;
    return Scaffold(
      appBar: BarraVidrio(
        title: const Text(
          'la pausa',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: -.7,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar bares',
            onPressed: modelo.cargando ? null : modelo.cargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Contenido(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            children: [
              Text(
                'Bares del campus',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'Cada espacio, sus productos y su historial de inspecciones.',
              ),
              const SizedBox(height: 28),
              if (modelo.cargando)
                const LinearProgressIndicator()
              else if (modelo.error.isNotEmpty)
                Aviso(mensaje: modelo.error, reintentar: modelo.cargar)
              else
                TarjetaVidrio(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Registro del campus',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${modelo.bares.length} ${modelo.bares.length == 1 ? 'bar' : 'bares'}',
                              style: const TextStyle(
                                fontFeatures: [FontFeature.tabularFigures()],
                                color: Colores.secundario,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (modelo.bares.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Registra el primer bar para comenzar.',
                            ),
                          ),
                        ...modelo.bares
                            .take(3)
                            .map(
                              (bar) => Column(
                                children: [
                                  const Divider(height: 1),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.detalleBar,
                                      arguments: bar,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bar.nombre,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(bar.ubicacion),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            bar.habilitado
                                                ? Icons.check_circle_outline
                                                : Icons.block_outlined,
                                            size: 20,
                                            color: bar.habilitado
                                                ? Colores.exito
                                                : Colores.textoPeligro,
                                            semanticLabel: bar.habilitado
                                                ? 'Habilitado'
                                                : 'Inhabilitado',
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.chevron_right,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            Text(
                              '$activos ${activos == 1 ? 'habilitado' : 'habilitados'}',
                            ),
                            Text(
                              '$inactivos ${inactivos == 1 ? 'inhabilitado' : 'inhabilitados'}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.bares),
                icon: const Icon(Icons.arrow_forward, size: 20),
                label: const Text('Gestionar bares'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.formularioBar),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Registrar un bar'),
              ),
              const SizedBox(height: 30),
              Text(
                'El estado de cada bar depende de su inspección más reciente.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (inactivos > 0) ...[
                const SizedBox(height: 16),
                Aviso(
                  mensaje:
                      '$inactivos ${inactivos == 1 ? 'bar requiere' : 'bares requieren'} una nueva inspección aprobada o aprobada con observaciones para volver a operar.',
                  esError: false,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
