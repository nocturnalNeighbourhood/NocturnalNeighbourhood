import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/getUserData.dart';

class Querybuilderpage extends StatefulWidget {
  final String skill;
  const Querybuilderpage({super.key, required this.skill});

  @override
  State<Querybuilderpage> createState() => _QuerybuilderpageState();
}

class _QuerybuilderpageState extends State<Querybuilderpage> {
  List<String> Skills = [];

  List<String> parseSkills(String input) {
    return input.split(RegExp(r'[,\s]+')).where((s) => s.isNotEmpty).toList();
  }

  @override
  void initState() {
    super.initState();
    Skills = parseSkills(widget.skill);
    print("skills are : $Skills");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Nocturnal Neighbourhood",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: Getuserdata().usersWithSkillStream(Skills),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final name = data['name'] ?? 'No Name';
                    final email = docs[index].id;
                    final skills = List<String>.from(data['skills'] ?? []);

                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey),
                        child: ListTile(
                          leading: const CircleAvatar(
                              child: Icon(
                            Icons.person,
                            color: Colors.white,
                          )),
                          title: Text(
                            name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            skills.join(", "),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            print("Tapped on $name");
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
