import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme(Brightness brightness) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorSchemeSeed: const Color(0xFF7B3FE4),
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
    appBarTheme: const AppBarTheme(centerTitle: true),
    // Newer Flutter expects CardThemeData
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}
