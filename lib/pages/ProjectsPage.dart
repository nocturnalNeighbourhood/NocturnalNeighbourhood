import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/Utils/projectTile.dart';

class Projectspage extends StatefulWidget {
  final String userEmail;
  final String currentEmail;
  const Projectspage({super.key, required this.userEmail, required this.currentEmail});

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
                    child: const Text(
                      "No projects yet",
                      style: TextStyle(color: Colors.white),
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
