import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: Colors.blue.shade400,
    secondary: Colors.grey.shade700,
    surface: Color(0xFF1F1F1F),
    tertiary: Colors.grey.shade300,
    inversePrimary: Colors.white,
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: Colors.white70,
    displayColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    elevation: 4,
    shadowColor: Colors.black,
    backgroundColor: Color(0xFF1A1A1A),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);
