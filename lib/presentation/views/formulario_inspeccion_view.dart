import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/bar.dart';
import '../../domain/entities/inspeccion.dart';
import '../../domain/validaciones.dart';
import '../viewmodels/inspeccion_viewmodel.dart';
import '../widgets/componentes.dart';

class FormularioInspeccionView extends StatefulWidget {
  const FormularioInspeccionView({super.key});
  @override
  State<FormularioInspeccionView> createState() =>
      _EstadoFormularioInspeccionView();
}

class _EstadoFormularioInspeccionView extends State<FormularioInspeccionView> {
  final formulario = GlobalKey<FormState>();
  final observacion = TextEditingController();
  final controladorFecha = TextEditingController();
  DateTime? fecha;
  String? resultado;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<InspeccionViewModel>().limpiarError();
    });
  }

  @override
  void dispose() {
    observacion.dispose();
    controladorFecha.dispose();
    super.dispose();
  }

  Future<void> seleccionarFecha() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: fecha ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'FECHA DE INSPECCIÓN',
      cancelText: 'Cancelar',
      confirmText: 'Seleccionar',
    );
    if (seleccionada == null || !mounted) return;
    setState(() {
      fecha = seleccionada;
      controladorFecha.text = mostrarFecha(
        seleccionada.toIso8601String().substring(0, 10),
      );
    });
  }

  void limpiar() {
    formulario.currentState!.reset();
    observacion.clear();
    controladorFecha.clear();
    setState(() {
      fecha = null;
      resultado = null;
    });
    context.read<InspeccionViewModel>().limpiarError();
    FocusScope.of(context).unfocus();
  }

  Future<void> guardar(Bar bar) async {
    if (!formulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final correcto = await context.read<InspeccionViewModel>().guardar(
      Inspeccion(
        barId: bar.id,
        fecha: fecha!.toIso8601String().substring(0, 10),
        observacion: observacion.text.trim(),
        resultado: resultado!,
      ),
    );
    if (!mounted || !correcto) return;
    mostrarMensaje(context, 'Inspección registrada.');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final modelo = context.watch<InspeccionViewModel>();
    final argumento = ModalRoute.of(context)?.settings.arguments;
    return PopScope(
      canPop: !modelo.guardando,
      child: Scaffold(
        appBar: BarraVidrio(title: const Text('Nueva inspección')),
        body: SafeArea(
          child: Contenido(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (argumento is! Bar)
                  const Aviso(
                    mensaje: 'Seleccione primero un bar para registrar una inspección.',
                  )
                else ...[
                  EncabezadoFormulario(
                    titulo: 'Registrar resultado',
                    descripcion:
                        'Registra la revisión de ${argumento.nombre}. El historial se conserva sin modificaciones.',
                  ),
                  Form(
                    key: formulario,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controladorFecha,
                          enabled: !modelo.guardando,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de inspección',
                            suffixIcon: Icon(Icons.calendar_month_outlined),
                          ),
                          onTap: seleccionarFecha,
                          validator: (_) => fecha == null
                              ? 'Seleccione la fecha de inspección.'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          key: ValueKey(resultado),
                          initialValue: resultado,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Resultado',
                          ),
                          items: Inspeccion.resultados
                              .map(
                                (opcion) => DropdownMenuItem(
                                  value: opcion,
                                  child: Text(opcion),
                                ),
                              )
                              .toList(),
                          onChanged: modelo.guardando
                              ? null
                              : (valor) => setState(() => resultado = valor),
                          validator: (valor) =>
                              valor == null ? 'Seleccione un resultado.' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: observacion,
                          enabled: !modelo.guardando,
                          minLines: 3,
                          maxLines: 6,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Observación',
                            alignLabelWithHint: true,
                            hintText: 'Describe la higiene y el funcionamiento revisados.',
                          ),
                          validator: (texto) => Validaciones.texto(
                            texto,
                            'la observación',
                            maximo: 1000,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Aviso(
                    mensaje: '«No aprobado» inhabilita el bar. «Aprobado» y «Aprobado con observaciones» permiten rehabilitarlo. Se considera la inspección más reciente por fecha; en un mismo día, la última registrada.',
                    esError: false,
                  ),
                  if (modelo.error.isNotEmpty) Aviso(mensaje: modelo.error),
                  FilledButton.icon(
                    onPressed: modelo.guardando
                        ? null
                        : () => guardar(argumento),
                    icon: const Icon(Icons.fact_check_outlined),
                    label: Text(
                      modelo.guardando ? 'Guardando…' : 'Registrar inspección',
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
