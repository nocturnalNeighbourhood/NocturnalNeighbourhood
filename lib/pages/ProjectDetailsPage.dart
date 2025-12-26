import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/Utils/MyTextField.dart';

class Projectdetailspage extends StatefulWidget {
  final String projectName;
  final Map<String, dynamic> project;
  final String creator;
  final String creatorEmail;
  final String currentEmail;
  const Projectdetailspage(
      {super.key,
      required this.projectName,
      required this.creatorEmail,
      required this.project,
      required this.creator,
      required this.currentEmail});

  @override
  State<Projectdetailspage> createState() => _ProjectdetailspageState();
}

class _ProjectdetailspageState extends State<Projectdetailspage> {
  final TextEditingController aboutController = TextEditingController();

  Future<String?> getName(String userEmail) async {
    final Name = await Getuserdata.name(userEmail);
    if (!mounted) return null;
    return Name;
  }

  Future<void> updateAbout(String projectID, String about) async {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectID)
        .update({
      'about': about,
    });
  }

  Future<void> updateStatus(String projectID, String status) async {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectID)
        .update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    final members = Map<String, dynamic>.from(widget.project['members']);
    final sortedMembers = members.entries.toList()
      ..sort((a, b) => a.key.toLowerCase().compareTo(b.key.toLowerCase()));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "${widget.projectName}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Project Name : ${widget.projectName}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Creator : ${widget.creator}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Project Status : ${widget.project['status']}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "About the project :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (widget.currentEmail == widget.creatorEmail)
                    ? () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("About ${widget.projectName} "),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Mytextfield(
                                          multiLine: true,
                                          textColor: Colors.black,
                                          hintText:
                                              "${(widget.project['about']) ?? "Write about your project..."}",
                                          obscureText: false,
                                          hintColor: Colors.black,
                                          controller: aboutController),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              aboutController.clear();
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                            onTap: () async {
                                              if (aboutController.text
                                                  .trim()
                                                  .isEmpty) return;

                                              //save about
                                              await updateAbout(
                                                  widget.project['id'],
                                                  aboutController.text.trim());

                                              if (!mounted) return;

                                              setState(() {
                                                widget.project['about'] =
                                                    aboutController.text.trim();
                                              });

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                "Updated the project description",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )));

                                              aboutController.clear();
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.black),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    "Save",
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
                                ));
                      }
                    : null,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            "${(widget.project['about'] ?? ((widget.currentEmail == widget.creatorEmail) ? "Tap to add project description" : "Not Specified"))}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 20),
              Text(
                "Members",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final entry = sortedMembers[index];
                  final email = entry.key;
                  final role = entry.value['role'];
                  final skills = List<String>.from(entry.value['skills'] ?? []);

                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String?>(
                            future: getName(email),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  "...",
                                  style: TextStyle(color: Colors.grey),
                                );
                              }

                              if (!snapshot.hasData || snapshot.data == null) {
                                return const Text(
                                  "Anonymous ^^",
                                  style: TextStyle(color: Colors.grey),
                                );
                              }

                              return Text(
                                snapshot.data!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            role,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          if (skills.isNotEmpty) ...[
                            SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: skills
                                  .map(
                                    (skill) => Chip(
                                      label: Text(skill),
                                      backgroundColor: Colors.blueGrey,
                                      labelStyle: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            title: Center(
                              child: Text(
                                "Change the Project status",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await updateStatus(
                                          widget.project['id'], "Ongoing");

                                      setState(() {
                                        widget.project['status'] = "Ongoing";
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                        "Updated the project status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )));

                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Ongoing",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await updateStatus(
                                          widget.project['id'], "Completed");

                                      setState(() {
                                        widget.project['status'] = "Completed";
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                        "Updated the project status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )));

                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Completed",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await updateStatus(
                                          widget.project['id'], "Cancelled");

                                      setState(() {
                                        widget.project['status'] = "Cancelled";
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                        "Updated the project status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )));

                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Cancelled",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )));
                  },
                  child: (widget.currentEmail == widget.creatorEmail)
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Change Project Status",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        )
                      : Text(""),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
