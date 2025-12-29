import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
  String? pfp = '';
  int nyx = 0;
  bool _isInviting = false;

  Future<void> getName(String userEmail) async {
    final Name = await Getuserdata.name(userEmail);
    if (!mounted) return;
    setState(() {
      name = Name;
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

  Future<bool> isAlreadyThere(String projectId, String toEmail) async {
    final doc = await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .get();

    if (!doc.exists) return false;

    final List<dynamic> listEmails = doc.data()?['memberEmails'] ?? [];

    return listEmails.contains(toEmail);
  }

  List<dynamic> userSkills = [];
  List<dynamic> selectedSkills = [];

  void showSkills(BuildContext context) async {
    Set<dynamic> tempSelected = Set.from(selectedSkills);
    bool contin = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Center(
              child: Text('Select skills',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white)),
            ),
            content: Container(
              height: 300,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: userSkills.length,
                itemBuilder: (context, index) {
                  final item = userSkills[index];
                  final isSelected = tempSelected.contains(item);

                  return CheckboxListTile(
                    fillColor: WidgetStateProperty.all(Colors.white),
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    title: Text(item,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                    value: isSelected,
                    onChanged: (bool? checked) {
                      setDialogState(() {
                        if (checked == true) {
                          tempSelected.add(item);
                        } else {
                          tempSelected.remove(item);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setDialogState(() {
                    selectedSkills = tempSelected.toList();
                  });
                  Navigator.pop(context);
                  print(selectedSkills);
                  contin = true;
                },
                child: Text('Done'),
              ),
            ],
          );
        });
      },
    );
    if (contin) {
      ChooseProjects(context, widget.currentUserEmail);
    }
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
              backgroundColor: Colors.grey[900],
              title: Center(
                child: Text(
                  "Invite $name to an existing project?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    //for existign projects
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[900],
                                title: Center(
                                  child: Text(
                                    "Choose a project",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
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

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.grey),
                                                      child: ListTile(
                                                        title: Text(
                                                          project[
                                                              'projectName'],
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
                                            onTap: () {
                                              for (int i = 0; i < 2; i++) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[600],
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
                                                ? () async {
                                                    if (_isInviting) return;
                                                    bool check =
                                                        await isAlreadyThere(
                                                            projectID, email!);
                                                    if (check) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                        "$name is already a member in your project ($projectName)!",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )));

                                                      for (int i = 0;
                                                          i < 2;
                                                          i++) {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    } else {
                                                      if (!mounted) return;
                                                      setState(() =>
                                                          _isInviting = true);
                                                      try {
                                                        await Invitations()
                                                            .invite(
                                                          true,
                                                          projectID,
                                                          email!,
                                                          widget
                                                              .currentUserEmail,
                                                          domain,
                                                          selectedSkills
                                                              .cast<String>(),
                                                          projectName,
                                                        );

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                                    content:
                                                                        Text(
                                                          "Invite sent!",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )));

                                                        for (int i = 0;
                                                            i < 2;
                                                            i++) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      } finally {
                                                        _isInviting = false;
                                                      }
                                                    }
                                                  }
                                                : null,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
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
                                                          color: Colors.black,
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
                            color: Colors.grey[600]),
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
                              backgroundColor: Colors.grey[900],
                              title: Center(
                                child: Text(
                                  "Give a name to your project",
                                  style: TextStyle(
                                      color: Colors.white,
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
                                        hintText: "Project Quantum Entangler",
                                        hintColor: Colors.white,
                                        obscureText: false,
                                        textColor: Colors.white,
                                        controller: projectNameController),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            for (int i = 0; i < 2; i++) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.grey[600]),
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
                                          onTap: () async {
                                            //send invite
                                            if (_isInviting) return;

                                            if ((projectNameController.text
                                                .trim()
                                                .isNotEmpty)) {
                                              if (!mounted) return;
                                              setState(
                                                  () => _isInviting = true);
                                              try {
                                                await Invitations().invite(
                                                    false,
                                                    null,
                                                    email!,
                                                    widget.currentUserEmail,
                                                    domain,
                                                    selectedSkills
                                                        .cast<String>(),
                                                    projectNameController.text
                                                        .trim());

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                  "Invite sent!",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )));

                                                for (int i = 0; i < 2; i++) {
                                                  Navigator.of(context).pop();
                                                }
                                              } finally {
                                                _isInviting = false;
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                "Enter project name!",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )));
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "Send Invite",
                                                  style: TextStyle(
                                                      color:
                                                          (projectNameController
                                                                  .text
                                                                  .trim()
                                                                  .isNotEmpty)
                                                              ? Colors.black
                                                              : Colors.black,
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
                            color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Create New Project",
                            style: TextStyle(
                                color: Colors.black,
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
    setState(() {
      selectedSkills = widget.reqSkills;
    });

    getName(email!);
    getPfp(email!);
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
                  Text(
                    about,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
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
                            userSkills = data['skills'] ?? [];

                            if (skills.isEmpty) {
                              return const Text("Not Specified");
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: skills.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ListTile(
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
                      showSkills(context);
                    },
                    child: (widget.UserEmail != widget.currentUserEmail)
                        ? Container(
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
                          )
                        : SizedBox.shrink(),
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
