import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Colores {
  static const fondo = Color(0xFF101315);
  static const superficie = Color(0xFF1D2226);
  static const elevada = Color(0xFF2B3135);
  static const borde = Color(0xFF3A4145);
  static const texto = Color(0xFFECEEEA);
  static const secundario = Color(0xFFABB2B3);
  static const primario = Color(0xFFCCD4CB);
  static const sobrePrimario = Color(0xFF151B18);
  static const observacion = Color(0xFFC6BDA4);
  static const exito = Color(0xFFA6C2B0);
  static const peligro = Color(0xFFCCA0A0);
  static const textoPeligro = Color(0xFFD7AAAA);
  static const informacion = Color(0xFFA9BAC6);
}

class Estilos {
  static const cifra = TextStyle(
    fontFeatures: [FontFeature.tabularFigures()],
    fontWeight: FontWeight.w600,
    fontSize: 32,
    height: 1.1,
    color: Colores.texto,
  );
  static const precio = TextStyle(
    fontFeatures: [FontFeature.tabularFigures()],
    fontWeight: FontWeight.w600,
    fontSize: 25,
    height: 1.2,
    color: Colores.texto,
  );
  static const etiqueta = TextStyle(
    fontSize: 12,
    letterSpacing: .2,
    fontWeight: FontWeight.w600,
    color: Colores.secundario,
  );
}

ThemeData crearTema() {
  final esquema = ColorScheme.fromSeed(
    seedColor: Colores.primario,
    brightness: Brightness.dark,
    primary: Colores.primario,
    onPrimary: Colores.sobrePrimario,
    primaryContainer: const Color(0xFF303934),
    onPrimaryContainer: Colores.primario,
    secondary: Colores.exito,
    onSecondary: Colores.fondo,
    secondaryContainer: Colores.elevada,
    onSecondaryContainer: Colores.texto,
    tertiary: Colores.informacion,
    onTertiary: Colores.fondo,
    surface: Colores.superficie,
    onSurface: Colores.texto,
    onSurfaceVariant: Colores.secundario,
    surfaceContainer: Colores.superficie,
    surfaceContainerHigh: Colores.elevada,
    surfaceContainerHighest: Colores.elevada,
    outline: Colores.borde,
    outlineVariant: Colores.borde,
    error: Colores.textoPeligro,
    onError: Colores.fondo,
    errorContainer: const Color(0xFF3B2C2E),
    onErrorContainer: Colores.textoPeligro,
  );
  final forma = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Manrope',
    colorScheme: esquema,
    scaffoldBackgroundColor: Colors.transparent,
    disabledColor: Colores.secundario.withValues(alpha: .4),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 29,
        height: 1.15,
        fontWeight: FontWeight.w600,
        letterSpacing: -.8,
        color: Colores.texto,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -.5,
        color: Colores.texto,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: Colores.texto,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: Colores.texto,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: Colores.texto),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Colores.secundario,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.4,
        color: Colores.secundario,
      ),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
    iconTheme: const IconThemeData(color: Colores.secundario, size: 22),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colores.fondo,
      foregroundColor: Colores.texto,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colores.texto,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colores.fondo,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colores.superficie.withValues(alpha: .65),
      labelStyle: const TextStyle(color: Colores.secundario),
      floatingLabelStyle: const TextStyle(color: Colores.primario),
      hintStyle: const TextStyle(color: Colores.secundario),
      helperStyle: const TextStyle(color: Colores.secundario),
      errorStyle: const TextStyle(color: Colores.textoPeligro),
      prefixIconColor: Colores.secundario,
      suffixIconColor: Colores.secundario,
      contentPadding: const EdgeInsets.all(18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colores.borde),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colores.borde),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colores.primario, width: 2),
      ),
      errorMaxLines: 3,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colores.primario,
      selectionColor: Colores.primario.withValues(alpha: .25),
      selectionHandleColor: Colores.primario,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colores.primario,
        foregroundColor: Colores.sobrePrimario,
        disabledBackgroundColor: Colores.elevada,
        disabledForegroundColor: Colores.secundario,
        minimumSize: const Size(48, 54),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        elevation: 0,
        shape: forma,
        textStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colores.texto,
        side: const BorderSide(color: Colores.borde),
        minimumSize: const Size(48, 52),
        shape: forma,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colores.primario,
        minimumSize: const Size(48, 48),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colores.primario,
      foregroundColor: Colores.sobrePrimario,
      elevation: 0,
      highlightElevation: 0,
      shape: forma,
    ),
    cardTheme: CardThemeData(
      color: Colores.superficie,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: forma.copyWith(side: const BorderSide(color: Colores.borde)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colores.superficie,
      selectedColor: const Color(0xFF303934),
      checkmarkColor: Colores.primario,
      labelStyle: const TextStyle(
        fontFamily: 'Manrope',
        color: Colores.texto,
        fontWeight: FontWeight.w500,
      ),
      side: const BorderSide(color: Colores.borde),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (estados) => estados.contains(WidgetState.selected)
            ? Colores.exito
            : Colores.secundario,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (estados) => estados.contains(WidgetState.selected)
            ? const Color(0xFF34483E)
            : Colores.elevada,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colores.superficie,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: forma,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colores.superficie,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colores.elevada,
      contentTextStyle: const TextStyle(
        fontFamily: 'Manrope',
        color: Colores.texto,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: forma,
    ),
    dividerTheme: const DividerThemeData(
      color: Colores.borde,
      space: 32,
      thickness: 1,
    ),
  );
}
