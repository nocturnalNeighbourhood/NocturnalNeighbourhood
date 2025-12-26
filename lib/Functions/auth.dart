import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/pages/HomePage.dart';
import 'package:nocturnal/pages/LoginPage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //if logged in
            if (snapshot.hasData) {
              final user = snapshot.data!;
              final Email = user.email;
              return HomePage(currentUserEmail: Email!);
            } else {
              return const Loginpage();
            }
          }),
    );
  }
}
