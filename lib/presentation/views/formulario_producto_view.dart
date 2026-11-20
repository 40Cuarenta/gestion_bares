import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/bar.dart';
import '../../domain/entities/producto.dart';
import '../../domain/validaciones.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../widgets/componentes.dart';

class FormularioProductoView extends StatefulWidget {
  const FormularioProductoView({super.key});
  @override
  State<FormularioProductoView> createState() =>
      _EstadoFormularioProductoView();
}

class _EstadoFormularioProductoView extends State<FormularioProductoView> {
  final formulario = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final precio = TextEditingController();
  final categoria = TextEditingController();
  Producto? producto;
  int? barId;
  bool disponible = true;
  bool iniciado = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (iniciado) return;
    iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    if (argumento is Producto) {
      producto = argumento;
      barId = argumento.barId;
      nombre.text = argumento.nombre;
      precio.text = argumento.precio.toStringAsFixed(2);
      categoria.text = argumento.categoria;
      disponible = argumento.disponible;
    } else if (argumento is Bar) {
      barId = argumento.id;
    }
    Future.microtask(() {
      if (mounted) context.read<ProductoViewModel>().limpiarError();
    });
  }

  @override
  void dispose() {
    nombre.dispose();
    precio.dispose();
    categoria.dispose();
    super.dispose();
  }

  void limpiar() {
    formulario.currentState!.reset();
    nombre.clear();
    precio.clear();
    categoria.clear();
    setState(() => disponible = true);
    context.read<ProductoViewModel>().limpiarError();
    FocusScope.of(context).unfocus();
  }

  Future<void> guardar() async {
    if (!formulario.currentState!.validate() || barId == null) return;
    FocusScope.of(context).unfocus();
    final correcto = await context.read<ProductoViewModel>().guardar(
      Producto(
        id: producto?.id ?? 0,
        barId: barId!,
        nombre: nombre.text.trim(),
        precio: double.parse(precio.text.trim().replaceAll(',', '.')),
        categoria: categoria.text.trim(),
        disponible: disponible,
      ),
    );
    if (!mounted || !correcto) return;
    mostrarMensaje(context, 'Producto guardado.');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<ProductoViewModel>();
    return PopScope(
      canPop: !modelo.guardando,
      child: Scaffold(
        appBar: BarraVidrio(
          title: Text(producto == null ? 'Nuevo producto' : 'Editar producto'),
        ),
        body: SafeArea(
          child: Contenido(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (barId == null)
                  const Aviso(
                    mensaje: 'Seleccione primero un bar para gestionar sus productos.',
                  )
                else ...[
                  const EncabezadoFormulario(
                    titulo: 'Datos del producto',
                    descripcion: 'El precio y la disponibilidad deben ser claros para todos.',
                  ),
                  Form(
                    key: formulario,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nombre,
                          enabled: !modelo.guardando,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del producto',
                          ),
                          validator: (texto) => Validaciones.texto(
                            texto,
                            'el nombre del producto',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: precio,
                          enabled: !modelo.guardando,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Precio',
                            prefixText: '\$ ',
                            helperText: 'Mayor que 0; hasta 2 decimales.',
                          ),
                          inputFormatters: [
                            TextInputFormatter.withFunction(
                              (anterior, nuevo) =>
                                  RegExp(r'^\d*([.,]\d{0,2})?$')
                                      .hasMatch(nuevo.text)
                                  ? nuevo
                                  : anterior,
                            ),
                          ],
                          validator: Validaciones.precio,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: categoria,
                          enabled: !modelo.guardando,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                            hintText: 'Ej.: Bebidas, desayunos, almuerzos',
                          ),
                          validator: (texto) => Validaciones.texto(
                            texto,
                            'la categoría',
                            maximo: 60,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Disponible para la venta'),
                          subtitle: const Text(
                            'Desactívalo cuando no se pueda vender. Un bar inhabilitado mantiene toda su oferta fuera de venta.',
                          ),
                          value: disponible,
                          onChanged: modelo.guardando
                              ? null
                              : (valor) => setState(() => disponible = valor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (modelo.error.isNotEmpty) Aviso(mensaje: modelo.error),
                  FilledButton.icon(
                    onPressed: modelo.guardando ? null : guardar,
                    icon: const Icon(Icons.check),
                    label: Text(
                      modelo.guardando ? 'Guardando…' : 'Guardar producto',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: modelo.guardando ? null : limpiar,
                    child: const Text('Limpiar campos'),
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
