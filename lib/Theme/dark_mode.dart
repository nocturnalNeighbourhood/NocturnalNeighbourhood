import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white, //myTextField
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF1F1F1F),
    secondary: Colors.black,
    surface: Colors.black38,
    surfaceContainer: Colors.black,
    onSurface: Colors.white,
    shadow: Colors.black,
    error: Colors.red,
  ),
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    elevation: 1,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white60),
  ),
);
