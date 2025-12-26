import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nocturnal/Utils/MyTextField.dart';
import 'package:nocturnal/pages/RegisterPage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //sign in
  void signIn() async {
    if (!mounted) return;

    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (!mounted) return;
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
      }
      return showMessage(e.code);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      showMessage("Something went wrong, try again");
    }
  }

  void showMessage(String message) {
    if (mounted) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(message),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Lottie.asset("lib/Animations/login_owl.json", height: 200),
                    SizedBox(
                      height: 20,
                    ),
                    Mytextfield(
                      hintText: "Email",
                      controller: emailController,
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Mytextfield(
                      hintText: "Password",
                      controller: passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Registerpage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account yet?",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey),
                          ),
                          Text(
                            " Register Now",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(onPressed: signIn, child: Text("Login")),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
