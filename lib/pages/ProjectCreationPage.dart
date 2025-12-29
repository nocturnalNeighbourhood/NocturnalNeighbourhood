import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/Utils/MyTextField.dart';

class ProjectCreationPage extends StatefulWidget {
  final String currentEmail;
  final String phoneNumber;
  const ProjectCreationPage(
      {super.key, required this.currentEmail, required this.phoneNumber});

  @override
  State<ProjectCreationPage> createState() => _ProjectCreationPageState();
}

class _ProjectCreationPageState extends State<ProjectCreationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  //final TextEditingController nameController = TextEditingController();
  // final TextEditingController nameController = TextEditingController();

  Future<void> createProject(String createrEmail, String phoneNumber) async {
    if (nameController.text.trim().isEmpty ||
        aboutController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Fill all the fields!",
        style: TextStyle(fontWeight: FontWeight.bold),
      )));

      return;
    }
    try {
      final firestore = FirebaseFirestore.instance;

      FirebaseFirestore.instance.collection('projects').doc().set(
        {
          'projectName': nameController.text.trim(),
          'createdAt': Timestamp.now(),
          'status': "Ongoing",
          "members": {
            createrEmail: {"role": "creator", "phoneNumber": phoneNumber},
          },
          "memberEmails": [createrEmail],
          "about": aboutController.text.trim(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Project Created!",
        style: TextStyle(fontWeight: FontWeight.bold),
      )));

      Navigator.pop(context);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Create Project",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Center(
                  child: Text(
                    "  Let's create\na new project!!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Name of the Project",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Mytextfield(
                    hintText: "Project Quantum Arc?",
                    obscureText: false,
                    controller: nameController),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "About the project",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Mytextfield(
                  hintText: "It's a top secret military project....",
                  obscureText: false,
                  controller: aboutController,
                  multiLine: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "You can add members later from your homepage after you finish creating this project.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await createProject(
                        widget.currentEmail, widget.phoneNumber);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[850]),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Create Project",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
