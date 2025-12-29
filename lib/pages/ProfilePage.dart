import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/pages/AboutPage.dart';
import 'package:nocturnal/pages/EditProfilePage.dart';
import 'package:nocturnal/pages/HomePage.dart';
import 'package:nocturnal/pages/ProjectsPage.dart';
import 'package:nocturnal/pages/RegisterPage.dart';
import 'package:nocturnal/pages/SettingsPage.dart';
import 'package:nocturnal/pages/ThemePage.dart';
import 'package:nocturnal/pages/showImages.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  String name = '';
  String about = '';
  String phoneNumber = '';
  String uid = '';
  String? email = '';
  String domain = '';
  String? pfp = '';
  int nyx = 0;

  Future<void> getName(String userEmail) async {
    final Name = await Getuserdata.name(userEmail);
    final PhoneNumber = await Getuserdata.phoneNumber(userEmail);
    if (!mounted) return;
    setState(() {
      name = Name;
      phoneNumber = PhoneNumber;
    });
    setState(() {});
  }

  Future<void> getPfp(String userEmail) async {
    final PFP = await Getuserdata.pfp(userEmail);
    if (!mounted) return;
    setState(() {
      pfp = PFP;
    });
    setState(() {});
  }

  Future<void> getAbout(String userEmail) async {
    final About = await Getuserdata.about(userEmail);
    final Nyx = await Getuserdata().getNyx(email!);
    if (!mounted) return;
    setState(() {
      about = About;
      nyx = Nyx;
    });
    setState(() {});
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      email = user.email;
      domain = email!.split('@').last;
      if (!mounted) return;
      setState(() {});
    }

    getName(email!);
    getPfp(email!);
    getAbout(email!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) async {
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(currentUserEmail: email!)));

          if (!mounted) return;
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: Colors.black,
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        endDrawer: Drawer(
          backgroundColor:
              Colors.grey[850], //Color.fromARGB(255, 119, 118, 118),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(padding: EdgeInsets.zero, children: [
              SizedBox(
                height: 100,
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Editprofilepage(
                            name: name,
                            about: about,
                            email: email!,
                            pfp: pfp!,
                          )));
                  if (!mounted) return;
                  setState(() {
                    getName(email!);
                    getPfp(email!);
                    getAbout(email!);
                  });
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text("Edit Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18))),
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Themepage()));
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text("Theme",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18))),
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Settingspage()));
                  if (!mounted) return;
                  setState(() {});
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text("Settings",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18))),
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Aboutpage()));
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text("About",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18))),
                ),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[850],
                          title: Center(
                            child: Text(
                              "Are you sure you want to log out?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                          content: SizedBox(
                            height: 80,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.grey),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //log out method gotta write dont forget vish!!
                                        signOut();
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.black),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              "Log out",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });

                  while (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text("Log Out",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18))),
                ),
              ),
            ]),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: (pfp!.isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 150,
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
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Editprofilepage(
                                pfp: pfp!,
                                name: name,
                                about: about,
                                email: email!)));
                        setState(() {
                          getName(email!);
                          getPfp(email!);
                          getAbout(email!);
                        });
                      },
                      child: Text(
                        about.isEmpty ? "Tap to add about" : about,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey[900],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            color: Colors.grey[900],
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "Projects",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  StreamBuilder<int>(
                                    stream:
                                        Getuserdata().getProjectsCount(email!),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();

                                      return Text(
                                        '${snapshot.data}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onLongPressDown: (LongPressDownDetails details) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[900],
                                    title: Center(
                                        child: Text('Nyx',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white))),
                                    content: Text(
                                        'Nyx measures how good someone is compared to another, the more the Nyx the more experienced you are. Join projects to increase your Nyx.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white)),
                                  );
                                },
                              );
                            },
                            child: Container(
                              color: Colors.grey[900],
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Text(
                                      "Nyx",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      nyx.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Text(
                            "Conquered:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(domain)
                                .collection('Details')
                                .doc(email)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              final data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              final List skills = data['skills'] ?? [];

                              if (skills.isEmpty) {
                                return Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Editprofilepage(
                                                      pfp: pfp!,
                                                      name: name,
                                                      about: about,
                                                      email: email!)));
                                      setState(() {});
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                            "Let the world know your expertise",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Text("(Tap to add skills)",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: skills.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: ListTile(
                                      //tileColor: Colors.grey[900],
                                      leading: const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                      ),
                                      title: Text(skills[index],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Projectspage(
                                  userEmail: email!,
                                  currentEmail: email!,
                                  phoneNumber: phoneNumber,
                                )));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 76, 76, 76),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Projects",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
