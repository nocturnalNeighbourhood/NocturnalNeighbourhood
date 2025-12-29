import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/Utils/projectTile.dart';
import 'package:nocturnal/pages/ProjectCreationPage.dart';

class Projectspage extends StatefulWidget {
  final String userEmail;
  final String currentEmail;
  final String phoneNumber;
  const Projectspage(
      {super.key,
      required this.userEmail,
      required this.currentEmail,
      required this.phoneNumber});

  @override
  State<Projectspage> createState() => _ProjectspageState();
}

class _ProjectspageState extends State<Projectspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Projects",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[850],
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProjectCreationPage(
                    currentEmail: widget.currentEmail,
                    phoneNumber: widget.phoneNumber,
                  )));
        },
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: Getuserdata().displayProjects(widget.userEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No projects yet",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data!.map((project) {
                    final members =
                        Map<String, dynamic>.from(project['members']);
                    final creatorEmail = members.entries
                        .firstWhere(
                          (e) => e.value['role'] == 'creator',
                          orElse: () => const MapEntry('', {}),
                        )
                        .key;
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Projecttile(
                        currentEmail: widget.currentEmail,
                        project: project,
                        projectName: project['projectName'],
                        status: project['status'],
                        creator: creatorEmail,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
