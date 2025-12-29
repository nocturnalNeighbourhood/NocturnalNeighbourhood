import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/pages/ProfilePageSearch.dart';
import 'package:rxdart/rxdart.dart';

class Querybuilderpage extends StatefulWidget {
  final String skill;
  final String currentUserEmail;
  const Querybuilderpage(
      {super.key, required this.skill, required this.currentUserEmail});

  @override
  State<Querybuilderpage> createState() => _QuerybuilderpageState();
}

class QuerySnapshotFake implements QuerySnapshot {
  @override
  final List<QueryDocumentSnapshot> docs;
  QuerySnapshotFake({this.docs = const []});
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _QuerybuilderpageState extends State<Querybuilderpage> {
  List<String> Skills = [];

  Stream<QuerySnapshot> combinedUsersStream(
      List<String> skills, String userName) {
    final skillStream = Getuserdata().usersWithSkillStream(skills) ??
        Stream.value(QuerySnapshotFake());
    final nameStream = Getuserdata().usersNamesStream(userName) ??
        Stream.value(QuerySnapshotFake());

    return CombineLatestStream.combine2(
      skillStream,
      nameStream,
      (QuerySnapshot a, QuerySnapshot b) {
        final allDocs = [...a.docs, ...b.docs];

        final uniqueDocs =
            {for (var doc in allDocs) doc.id: doc}.values.toList();

        return QuerySnapshotFake(docs: uniqueDocs);
      },
    );
  }

  List<String> controlSkills(String input) {
    final List<String> listSkills = input
        .toLowerCase()
        .split(RegExp(r'[,\s]+'))
        .where((s) => s.isNotEmpty)
        .toList();

    for (int i = 0; i < listSkills.length; i++) {
      String skill = listSkills[i];
      if (skill == "flutter") {
        listSkills[i] = "flutter";
      } else if (skill == "c#" || skill == "csharp") {
        listSkills[i] = "c#";
      } else if (skill == "html") {
        listSkills[i] = "html";
      } else if (skill == "c++" || skill == "cpp") {
        listSkills[i] = "c++";
      }
    }

    //print("hellooooo : $listSkills");

    return listSkills;
  }

  String capForFirstLetters(String userName) {
    if (userName.isEmpty) return userName;

    return userName.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  void initState() {
    super.initState();
    Skills = controlSkills(widget.skill);
    //print("skills are : $Skills");
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
              stream:
                  combinedUsersStream(Skills, capForFirstLetters(widget.skill)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Text(
                          "Searching for ${Skills.toString().substring(1).replaceAll("]", "")}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: [
                      Center(
                          child: Lottie.asset(
                              "lib/Animations/heresNothingOwl.json",
                              height: 400)),
                      Text(
                        "Our search for the treasure yielded no fruit",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                }

                final docs = snapshot.data!.docs;

                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;

                        final name = data['name'] ?? 'No Name';
                        final email = docs[index].id;
                        final skills = List<String>.from(data['skills'] ?? []);
                        final pfp = data['pfp'];

                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[850]),
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
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
                                //print("Tapped on $name");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Profilepagesearch(
                                          UserEmail: email,
                                          currentUserEmail:
                                              widget.currentUserEmail,
                                          reqSkills: [
                                            Skills.toString()
                                                .substring(1)
                                                .replaceAll("]", "")
                                          ],
                                        )));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
