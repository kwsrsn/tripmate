import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    textTheme: GoogleFonts.averiaLibreTextTheme(),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF9FCBAD),
      secondary: Color(0xFFE4DDBE),
      surface: Color(0xFFF1F7D4),
      error: Color(0xFFCE5151),
      onPrimary: Color(0xFF563D2B),
      onSurface: Color(0xFF563D2B)
    ),
    useMaterial3: true,
  );
}