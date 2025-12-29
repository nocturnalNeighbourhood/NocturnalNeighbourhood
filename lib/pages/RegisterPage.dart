import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nocturnal/Functions/createUserData.dart';
import 'package:nocturnal/Utils/MyTextField.dart';
import 'package:nocturnal/pages/LoginPage.dart';
import 'package:nocturnal/pages/showImages.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? pfp = "";

  String capForFirstLetters(String userName) {
    if (userName.isEmpty) return userName;

    return userName.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  //sign up
  void signUp() async {
    if (!mounted) return;

    final name = capForFirstLetters(nameController.text.trim());

    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    if (passwordController.text == confirmPasswordController.text) {
      try {
        final usercred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: "${emailController.text.trim()}@iiitg.ac.in",
                password: passwordController.text);
        final domain =
            "${emailController.text.trim()}@iiitg.ac.in".split('@').last;

        String uid = usercred.user!.uid;

        await UserData().CreateUserData(
          pass: passwordController.text.trim(),
          pfp: pfp!,
          uid: uid,
          domain: domain,
          email: "${emailController.text.trim()}@iiitg.ac.in",
          name: name,
          phoneNumber: phoneController.text.trim(),
        );

        if (!mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        pfp = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => Showimages())) ??
                            pfp;

                        setState(() {});
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: (pfp!.isEmpty)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 150,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      "Tap to add Profile Pic",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                  )
                                ],
                              )
                            : ClipOval(
                                child: Image.asset(
                                  pfp!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
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
                      isEmail: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Mytextfield(
                      hintText: "Phone Number",
                      controller: phoneController,
                      isPhonenumber: true,
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Loginpage()));
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
                    ElevatedButton(
                        onPressed: pfp!.isEmpty
                            ? () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text(
                                  "Choose a profile pic",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )));
                              }
                            : signUp,
                        child: Text("Register")),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
