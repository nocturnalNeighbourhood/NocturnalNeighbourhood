import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/Utils/InvitationTile.dart';
import 'package:nocturnal/pages/HomePage.dart';
import 'package:nocturnal/pages/ProjectDetailsPage.dart';

class Invitationspage extends StatefulWidget {
  final String domain;
  final String userEmail;
  const Invitationspage(
      {super.key, required this.userEmail, required this.domain});

  @override
  State<Invitationspage> createState() => _InvitationspageState();
}

class _InvitationspageState extends State<Invitationspage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) async {
        if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  HomePage(currentUserEmail: widget.userEmail)));

          if (!mounted) return;
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Invitations",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: Getuserdata()
                      .invitationsChannel(widget.domain, widget.userEmail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset("lib/Animations/login_owl.json",
                              height: 200),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              "No invitations yet",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      );
                    }

                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: snapshot.data!.map((invite) {
                        //print("reciever is: ${invite['receiver']}");
                        return GestureDetector(
                          onLongPress: (invite['existingProject'] ?? false)
                              ? () async {
                                  final ref = await FirebaseFirestore.instance
                                      .collection('projects')
                                      .doc(invite['projectID'])
                                      .get();

                                  final projectData =
                                      ref.data() as Map<String, dynamic>;

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Projectdetailspage(
                                          projectName: invite['projectName'],
                                          creatorEmail: invite['sender'],
                                          project: projectData,
                                          creator: invite['sender'],
                                          currentEmail: widget.userEmail)));
                                }
                              : null,
                          child: Invitationtile(
                            ProjectID: invite['projectID'] ?? "",
                            existingProject: invite['existingProject'] ?? false,
                            inviteId: invite['id'],
                            receiverEmail: invite['receiver'] ?? '',
                            projectName:
                                invite['projectName'] ?? 'Unknown Project',
                            skills: invite['reqSkills'] ?? ["Not specified"],
                            currentEmail: widget.userEmail,
                            senderEmail: invite['sender'] ?? '',
                            status: invite['status'],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
