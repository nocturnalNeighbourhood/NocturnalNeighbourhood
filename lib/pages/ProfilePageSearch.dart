import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/Invitations.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/Utils/MyTextField.dart';
import 'package:nocturnal/pages/ProjectDetailsPage.dart';

class Profilepagesearch extends StatefulWidget {
  final String UserEmail;
  final String currentUserEmail;
  final List<String> reqSkills;
  const Profilepagesearch(
      {super.key,
      required this.UserEmail,
      required this.currentUserEmail,
      required this.reqSkills});

  @override
  State<Profilepagesearch> createState() => _ProfilepagesearchState();
}

class _ProfilepagesearchState extends State<Profilepagesearch> {
  final TextEditingController projectNameController = TextEditingController();

  String name = '';
  String about = '';
  String uid = '';
  String? email = '';
  String domain = '';
  String projectID = '';
  String projectName = '';
  bool check = false;

  Future<void> getName(String userEmail) async {
    final Name = await Getuserdata.name(userEmail);
    if (!mounted) return;
    setState(() {
      name = Name;
    });
    setState(() {});
  }

  Future<void> getAbout(String userEmail) async {
    final About = await Getuserdata.about(userEmail);
    if (!mounted) return;
    setState(() {
      about = About;
    });
    setState(() {});
  }

  void ChooseProjects(BuildContext context, String email1) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('projects').get();

    final creatorProps = snapshot.docs.where((doc) {
      final members = Map<String, dynamic>.from(doc['members']);
      return members.entries.any(
        (e) => e.key == email1 && e.value['role'] == 'creator',
      );
    }).toList();

    if (!context.mounted) return;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Invite $name to an existing project?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
                              return AlertDialog(
                                title: const Text(
                                  "Choose a project",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: creatorProps.isEmpty
                                            ? Center(
                                                child: Text(
                                                  "No projects found",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              )
                                            : ListView.builder(
                                                itemCount: creatorProps.length,
                                                itemBuilder: (context, index) {
                                                  final doc =
                                                      creatorProps[index];
                                                  final project = doc.data()
                                                      as Map<String, dynamic>;

                                                  if (project['status'] !=
                                                      "Ongoing") {
                                                    return SizedBox.shrink();
                                                  }

                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Colors.grey),
                                                    child: ListTile(
                                                      title: Text(
                                                        project['projectName'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      trailing: projectID ==
                                                              doc.id
                                                          ? Icon(Icons.check)
                                                          : null,
                                                      onTap: () {
                                                        setDialogState(() {
                                                          projectName = project[
                                                              'projectName'];
                                                          projectID = doc.id;
                                                          check = true;
                                                        });
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text("Cancel",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: check
                                                ? () {
                                                    Invitations().invite(
                                                      true,
                                                      projectID,
                                                      email!,
                                                      widget.currentUserEmail,
                                                      domain,
                                                      widget.reqSkills,
                                                      projectName,
                                                    );
                                                    Navigator.pop(context);
                                                  }
                                                : null,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      "Send Invite",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Existing Project",
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
                      //create new
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Center(
                                child: Text(
                                  "Give a name to your project",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              content: SizedBox(
                                height: 130,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Mytextfield(
                                        hintText: "Project Ultron",
                                        hintColor: Colors.black,
                                        obscureText: false,
                                        textColor: Colors.black,
                                        controller: projectNameController),
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //send invite
                                            Invitations().invite(
                                                false,
                                                null,
                                                email!,
                                                widget.currentUserEmail,
                                                domain,
                                                widget.reqSkills,
                                                projectNameController.text
                                                    .trim());

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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "Send Invite",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Create New Project",
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
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    email = widget.UserEmail;
    domain = email!.split('@').last;
    setState(() {});

    getName(email!);
    getAbout(email!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "$name",
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
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      height: 200,
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
                  Text(
                    about,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
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
                                  minVerticalPadding: 0,
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
                  GestureDetector(
                    onTap: () {
                      ChooseProjects(context, widget.currentUserEmail);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 76, 76, 76),
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          "Ask for Collaboration",
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
    );
  }
}
