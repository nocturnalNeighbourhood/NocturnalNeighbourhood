import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  /*primaryColor: Colors.white, //myTextField
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
  ),*/

  primaryColor: Color.fromARGB(206, 94, 105, 115), //for textfields
  colorScheme: ColorScheme.dark(
    primary: Color.fromARGB(255, 20, 20, 20),
    secondary: Colors.blue,
    surface: Colors.white,
    surfaceContainer: Colors.white,
    onSurface: Colors.black,
    shadow: Color.fromARGB(58, 0, 0, 0),
    error: Colors.red,
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 253, 255, 252),
  //scaffoldBackgroundColor: Color.fromARGB(255, 249, 234, 225),
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
    //backgroundColor: Color.fromARGB(255, 170, 68, 101),
    //backgroundColor: Color.fromARGB(255, 46, 196, 182),
    backgroundColor: Color.fromARGB(255, 253, 255, 252),
    //backgroundColor: Color.fromARGB(255, 1, 22, 56),
    elevation: 1,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white)),
);
