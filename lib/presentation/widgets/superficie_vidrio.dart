import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../tema/tema_app.dart';

class FondoAplicacion extends StatelessWidget {
  const FondoAplicacion({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF303936), Color(0xFF171C1F), Colores.fondo],
        stops: [0, .45, 1],
      ),
    ),
    child: child,
  );
}

class TarjetaVidrio extends StatelessWidget {
  const TarjetaVidrio({
    super.key,
    required this.child,
    this.clipBehavior = Clip.antiAlias,
  });
  final Widget child;
  final Clip clipBehavior;
  @override
  Widget build(BuildContext context) {
    final altoContraste = MediaQuery.highContrastOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        enabled: !altoContraste,
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: altoContraste
                  ? [Colores.superficie, Colores.superficie]
                  : [const Color(0xD9353E3D), const Color(0xD9191E22)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: altoContraste ? .35 : .12),
            ),
          ),
          child: Material(type: MaterialType.transparency, child: child),
        ),
      ),
    );
  }
}

class BarraVidrio extends StatelessWidget implements PreferredSizeWidget {
  const BarraVidrio({super.key, required this.title, this.actions});
  final Widget title;
  final List<Widget>? actions;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) => ClipRect(
    child: BackdropFilter(
      enabled: !MediaQuery.highContrastOf(context),
      filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: AppBar(
        title: title,
        actions: actions,
        backgroundColor: Colores.fondo.withValues(alpha: .65),
        shape: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: .06)),
        ),
      ),
    ),
  );
}
