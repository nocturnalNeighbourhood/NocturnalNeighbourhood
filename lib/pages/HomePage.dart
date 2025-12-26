import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/Utils/MyTextField.dart';
import 'package:nocturnal/pages/InvitationsPage.dart';
import 'package:nocturnal/pages/ProfilePage.dart';
import 'package:nocturnal/pages/QueryBuilderPage.dart';

class HomePage extends StatefulWidget {
  final String currentUserEmail;
  const HomePage({super.key, required this.currentUserEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Invitationspage(domain: widget.currentUserEmail.split('@').last, userEmail: widget.currentUserEmail,)));
          },
          child: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Profilepage()));
              },
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.black,
        title: const Text(
          "Nocturnal Neighbourhood",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Heyy what are you",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                  Text(
                    "looking for today?",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "(UI/UX, Flutter, HTML, CSS, Java, React)",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  Lottie.asset('lib/Animations/owl_waving.json', height: 150),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Mytextfield(
                controller: queryController,
                obscureText: false,
                hintText: "Search for UI designers for your app",
                fontSize: 16,
                iconButton: Icons.near_me,
                onTap: () {
                  final String Skills = queryController.text.trim();
                  if (queryController.text.isEmpty) return;

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Querybuilderpage(
                            skill: Skills,
                            currentUserEmail: widget.currentUserEmail,
                          )));

                  queryController.clear();
                  print("query text ${Skills}");
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
