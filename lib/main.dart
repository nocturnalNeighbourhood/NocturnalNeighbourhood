import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/auth.dart';
import 'package:nocturnal/Theme/dark_mode.dart';
import 'package:nocturnal/Theme/light_mode.dart';
import 'package:nocturnal/firebase_options.dart';
import 'package:nocturnal/pages/HomePage.dart';
import 'package:nocturnal/pages/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: AuthPage()); 
  }
}
