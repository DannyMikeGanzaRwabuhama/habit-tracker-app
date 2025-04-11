import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey.shade100,
  colorScheme: ColorScheme.light(
    primary: Colors.blue.shade600,
    secondary: Colors.grey.shade200,
    surface: Colors.white,
    tertiary: Colors.grey.shade700,
    inversePrimary: Colors.black,
  ),
  textTheme: GoogleFonts.poppinsTextTheme().apply(
    bodyColor: Colors.black87,
    displayColor: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    elevation: 4,
    shadowColor: Colors.black12,
    backgroundColor: Colors.blue.shade50,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.blue.shade900,
    ),
  ),
);
