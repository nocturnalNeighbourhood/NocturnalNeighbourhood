import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/Utils/MyTextField.dart';
import 'package:nocturnal/pages/showImages.dart';

class Editprofilepage extends StatefulWidget {
  final String name;
  final String about;
  final String email;
  final String pfp;
  const Editprofilepage(
      {super.key,
      required this.pfp,
      required this.name,
      required this.about,
      required this.email});

  @override
  State<Editprofilepage> createState() => _EditprofilepageState();
}

class _EditprofilepageState extends State<Editprofilepage> {
  var nameController = TextEditingController();
  var aboutController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  String email = '';
  String domain = '';
  String? pfp = "";
  int changesMade = 0;

  Future<void> addSkill(String skill1) async {
    final user = FirebaseAuth.instance.currentUser!;
    final domain = user.email!.split('@').last;
    final skill = skill1.toLowerCase();

    if (skill.isEmpty) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(domain)
        .collection("Details")
        .doc(email)
        .update({
      'skills': FieldValue.arrayUnion([skill]),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      "Skill added!",
      style: TextStyle(fontWeight: FontWeight.bold),
    )));

    changesMade++;
    if (!mounted) return;
    setState(() {});

    skillController.clear();
  }

  Future<void> removeSkill(String skill) async {
    final user = FirebaseAuth.instance.currentUser!;
    final domain = user.email!.split('@').last;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(domain)
        .collection("Details")
        .doc(email)
        .update({
      'skills': FieldValue.arrayRemove([skill]),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      "Skill removed!",
      style: TextStyle(fontWeight: FontWeight.bold),
    )));

    changesMade--;
    if (!mounted) return;
    setState(() {});
  }

  bool checkChanges() {
    return (((widget.name != nameController.text) &&
                (nameController.text.isNotEmpty)) ||
            ((widget.about != aboutController.text) &&
                (aboutController.text.isNotEmpty)) ||
            widget.pfp != pfp)
        ? true
        : false;
  }

  Future<void> updateProfile({
    required String newName,
    required String newAbout,
    required String newPfp,
  }) async {
    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(domain)
        .collection("Details")
        .doc(email);

    (newName != widget.name) && newName.isNotEmpty
        ? {
            await ref.update({'name': newName})
          }
        : null;
    (newAbout != widget.about) && newAbout.isNotEmpty
        ? {
            ref.update({'about': newAbout})
          }
        : null;
    (newPfp != widget.pfp) && newPfp.isNotEmpty
        ? {
            await ref.update({'pfp': newPfp})
          }
        : null;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Profile Updated")));

    Navigator.pop(context);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void initState() {
    email = widget.email;
    domain = widget.email.split('@').last;
    super.initState();
    nameController = TextEditingController(text: widget.name);
    aboutController = TextEditingController(text: widget.about);
    pfp = widget.pfp;
    nameController.addListener(_onTextChanged);
    aboutController.addListener(_onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: checkChanges()
                  ? () async {
                      await updateProfile(
                          newName: nameController.text.trim(),
                          newAbout: aboutController.text.trim(),
                          newPfp: pfp!);
                      Navigator.pop(context);
                    }
                  : (changesMade != 0)
                      ? () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Profile Updated")));
                          Navigator.pop(context);
                        }
                      : null,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: (checkChanges() || (changesMade != 0))
                        ? Colors.white
                        : Colors.grey),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 8, left: 8, top: 4, bottom: 4),
                  child: Text("Save",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.black,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                    child: GestureDetector(
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
                  ),
                  SizedBox(height: 20),
                  Text("Edit Details",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                  SizedBox(height: 20),
                  Mytextfield(
                      hintText: "Name",
                      obscureText: false,
                      controller: nameController),
                  SizedBox(
                    height: 20,
                  ),
                  Mytextfield(
                      hintText: "About",
                      obscureText: false,
                      controller: aboutController),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Text(
                          "Mastered:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Mytextfield(
                                controller: skillController,
                                hintText: "Add a skill",
                                obscureText: false,
                                onTap: () {
                                  addSkill(skillController.text.trim());
                                },
                                iconButton: Icons.add,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
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
                              return const Text("No skills added yet");
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: skills.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  trailing: GestureDetector(
                                      onTap: () {
                                        removeSkill(skills[index]);
                                      },
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                      )),
                                  leading: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                  title: Text(skills[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
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
                  /*Container(
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
                  )*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
