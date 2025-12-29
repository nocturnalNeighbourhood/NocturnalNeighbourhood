import 'package:firebase_auth/firebase_auth.dart';
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
  String uid = '';
  String? email = '';
  String domain = '';
  int newInvites = 0;

  Future<void> getPendingInvites(String userEmail) async {
    final NewInvites =
        await Getuserdata().getPendingInvitationsCount(domain, userEmail);
    if (!mounted) return;
    setState(() {
      newInvites = NewInvites;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      email = user.email;
      domain = email!.split('@').last;
      setState(() {});
    }

    getPendingInvites(email!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) async {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Invitationspage(
                    domain: widget.currentUserEmail.split('@').last,
                    userEmail: widget.currentUserEmail,
                  )));

          if (!mounted) return;
          setState(() {});
          getPendingInvites(email!);
        }

        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Profilepage()));
          if (!mounted) return;
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Invitationspage(
                        domain: widget.currentUserEmail.split('@').last,
                        userEmail: widget.currentUserEmail,
                      )));

              if (!mounted) return;
              setState(() {});
              getPendingInvites(email!);
            },
            child: Stack(children: [
              Center(
                child: Icon(
                  Icons.notifications,
                  color: (newInvites != 0)
                      ? Color.fromARGB(255, 33, 243, 205)
                      : Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 10),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      (newInvites != 0) ? newInvites.toString() : "",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 33, 243, 205)),
                    )),
              )
            ]),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Profilepage()));
                  if (!mounted) return;
                  setState(() {});
                },
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.black,
          title: Text(
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
                    //print("query text ${Skills}");
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
