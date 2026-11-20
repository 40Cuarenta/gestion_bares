import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/bar.dart';
import '../../domain/validaciones.dart';
import '../viewmodels/bar_viewmodel.dart';
import '../widgets/componentes.dart';

class FormularioBarView extends StatefulWidget {
  const FormularioBarView({super.key});
  @override
  State<FormularioBarView> createState() => _EstadoFormularioBarView();
}

class _EstadoFormularioBarView extends State<FormularioBarView> {
  final formulario = GlobalKey<FormState>();
  final nombre = TextEditingController();
  final ubicacion = TextEditingController();
  final responsable = TextEditingController();
  Bar? bar;
  bool iniciado = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (iniciado) return;
    iniciado = true;
    final argumento = ModalRoute.of(context)?.settings.arguments;
    if (argumento is Bar) {
      bar = argumento;
      nombre.text = argumento.nombre;
      ubicacion.text = argumento.ubicacion;
      responsable.text = argumento.responsable;
    }
    Future.microtask(() {
      if (mounted) context.read<BarViewModel>().limpiarError();
    });
  }

  @override
  void dispose() {
    nombre.dispose();
    ubicacion.dispose();
    responsable.dispose();
    super.dispose();
  }

  void limpiar() {
    formulario.currentState!.reset();
    nombre.clear();
    ubicacion.clear();
    responsable.clear();
    context.read<BarViewModel>().limpiarError();
    FocusScope.of(context).unfocus();
  }

  Future<void> guardar() async {
    if (!formulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final correcto = await context.read<BarViewModel>().guardar(
      Bar(
        id: bar?.id ?? 0,
        nombre: nombre.text.trim(),
        ubicacion: ubicacion.text.trim(),
        responsable: responsable.text.trim(),
        habilitado: bar?.habilitado ?? true,
      ),
    );
    if (!mounted || !correcto) return;
    mostrarMensaje(context, 'Bar guardado.');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<BarViewModel>();
    return PopScope(
      canPop: !modelo.guardando,
      child: Scaffold(
        appBar: BarraVidrio(
          title: Text(bar == null ? 'Nuevo bar' : 'Editar bar'),
        ),
        body: SafeArea(
          child: Contenido(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const EncabezadoFormulario(
                  titulo: 'Datos del bar',
                  descripcion: 'Registra su información para mantener un campus organizado.',
                ),
                Form(
                  key: formulario,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nombre,
                        enabled: !modelo.guardando,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del bar',
                        ),
                        validator: (texto) =>
                            Validaciones.texto(texto, 'el nombre del bar'),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: ubicacion,
                        enabled: !modelo.guardando,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Ubicación',
                          hintText: 'Ej.: Bloque B, planta baja',
                        ),
                        validator: (texto) => Validaciones.texto(
                          texto,
                          'la ubicación',
                          maximo: 150,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: responsable,
                        enabled: !modelo.guardando,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Responsable',
                        ),
                        validator: Validaciones.responsable,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (modelo.error.isNotEmpty) Aviso(mensaje: modelo.error),
                const Aviso(
                  mensaje: 'La habilitación del bar se actualiza mediante sus inspecciones.',
                  esError: false,
                ),
                FilledButton.icon(
                  onPressed: modelo.guardando ? null : guardar,
                  icon: const Icon(Icons.check),
                  label: Text(modelo.guardando ? 'Guardando…' : 'Guardar bar'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: modelo.guardando ? null : limpiar,
                  child: const Text('Limpiar campos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
