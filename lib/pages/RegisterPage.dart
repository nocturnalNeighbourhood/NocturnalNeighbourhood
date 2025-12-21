import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/createUserData.dart';
import 'package:nocturnal/Utils/MyTextField.dart';
import 'package:nocturnal/pages/LoginPage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  //sign up
  void signUp() async {
    if (!mounted) return;

    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    if (passwordController.text == confirmPasswordController.text) {
      try {
        final usercred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        final domain = emailController.text.split('@').last;

        String uid = usercred.user!.uid;

        await UserData().CreateUserData(
          uid: uid,
          domain: domain,
          email: emailController.text,
          name: nameController.text,
        );

        if (!mounted) return;
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (mounted) Navigator.pop(context);
        return showMessage(e.code);
      }
    } else {
      return showMessage("Passwords don't match!");
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
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Spacer(),
              Mytextfield(
                hintText: "Name",
                controller: nameController,
                obscureText: false,
              ),
              SizedBox(height: 20),
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
              SizedBox(
                height: 20,
              ),
              Mytextfield(
                hintText: "Confirm Password",
                controller: confirmPasswordController,
                obscureText: true,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Loginpage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
                    Text(
                      " Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: signUp, child: Text("Register")),
            ],
          ),
        ));
  }
}
