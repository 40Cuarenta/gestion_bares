import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'data/datasources/cliente_api.dart';
import 'presentation/tema/tema_app.dart';
import 'presentation/widgets/superficie_vidrio.dart';
import 'routes/app_routes.dart';
import 'data/datasources/bar_api.dart';
import 'data/repositories/bar_repository_impl.dart';
import 'presentation/viewmodels/bar_viewmodel.dart';
import 'data/datasources/producto_api.dart';
import 'data/repositories/producto_repository_impl.dart';
import 'presentation/viewmodels/producto_viewmodel.dart';
import 'data/datasources/inspeccion_api.dart';
import 'data/repositories/inspeccion_repository_impl.dart';
import 'presentation/viewmodels/inspeccion_viewmodel.dart';
import 'domain/usecases/obtener_bares.dart';
import 'domain/usecases/crear_bar.dart';
import 'domain/usecases/actualizar_bar.dart';
import 'domain/usecases/eliminar_bar.dart';
import 'domain/usecases/obtener_productos.dart';
import 'domain/usecases/crear_producto.dart';
import 'domain/usecases/actualizar_producto.dart';
import 'domain/usecases/eliminar_producto.dart';
import 'domain/usecases/obtener_inspecciones.dart';
import 'domain/usecases/registrar_inspeccion.dart';
import 'presentation/views/inicio_view.dart';
import 'presentation/views/bares_view.dart';
import 'presentation/views/formulario_bar_view.dart';
import 'presentation/views/detalle_bar_view.dart';
import 'presentation/views/formulario_producto_view.dart';
import 'presentation/views/formulario_inspeccion_view.dart';

void main() {
  runApp(const AplicacionBares());
}

class AplicacionBares extends StatefulWidget {
  const AplicacionBares({super.key, this.cliente});
  final ClienteApi? cliente;
  @override
  State<AplicacionBares> createState() => _EstadoAplicacionBares();
}

class _EstadoAplicacionBares extends State<AplicacionBares> {
  late final ClienteApi cliente;
  late final BarRepositoryImpl bares;
  late final ProductoRepositoryImpl productos;
  late final InspeccionRepositoryImpl inspecciones;

  @override
  void initState() {
    super.initState();
    cliente = widget.cliente ?? ClienteApi();
    bares = BarRepositoryImpl(BarApi(cliente));
    productos = ProductoRepositoryImpl(ProductoApi(cliente));
    inspecciones = InspeccionRepositoryImpl(InspeccionApi(cliente));
  }

  @override
  void dispose() {
    if (widget.cliente == null) cliente.cerrar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => BarViewModel(
          ObtenerBares(bares),
          CrearBar(bares),
          ActualizarBar(bares),
          EliminarBar(bares),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductoViewModel(
          ObtenerProductos(productos),
          CrearProducto(productos),
          ActualizarProducto(productos),
          EliminarProducto(productos),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => InspeccionViewModel(
          ObtenerInspecciones(inspecciones),
          RegistrarInspeccion(inspecciones),
        ),
      ),
    ],
    child: MaterialApp(
      title: 'La pausita de la u · Bares del campus',
      locale: const Locale('es', 'EC'),
      supportedLocales: const [Locale('es', 'EC')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      theme: crearTema(),
      builder: (context, child) => FondoAplicacion(child: child!),
      initialRoute: AppRoutes.inicio,
      routes: {
        AppRoutes.inicio: (_) => const InicioView(),
        AppRoutes.bares: (_) => const BaresView(),
        AppRoutes.formularioBar: (_) => const FormularioBarView(),
        AppRoutes.detalleBar: (_) => const DetalleBarView(),
        AppRoutes.formularioProducto: (_) => const FormularioProductoView(),
        AppRoutes.formularioInspeccion: (_) => const FormularioInspeccionView(),
      },
    ),
  );
}
