import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/Invitations.dart';
import 'package:nocturnal/Functions/getUserData.dart';

class Invitationtile extends StatefulWidget {
  final String projectName;
  final String receiverEmail;
  final List<dynamic> skills;
  final String senderEmail;
  final String currentEmail;
  final String status;
  final String inviteId;
  final String ProjectID;
  final bool existingProject;
  const Invitationtile(
      {super.key,
      required this.existingProject,
      required this.ProjectID,
      required this.projectName,
      required this.skills,
      required this.currentEmail,
      required this.senderEmail,
      required this.status,
      required this.receiverEmail,
      required this.inviteId});

  @override
  State<Invitationtile> createState() => _InvitationtileState();
}

class _InvitationtileState extends State<Invitationtile> {
  String receiverName = '';
  String senderName = '';

  Future<void> getName(String userEmail, String who) async {
    final Name = await Getuserdata.name(userEmail);
    if (!mounted) return;
    setState(() {
      if (who == "sender") {
        senderName = Name;
        print("sender name : $senderName");
      } else {
        receiverName = Name;
        print("receiver name : $receiverName");
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentEmail == widget.senderEmail) {
      getName(widget.receiverEmail, "receiver");
    } else {
      getName(widget.senderEmail, "sender");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSender = (widget.senderEmail == widget.currentEmail);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 40,
                        ),
                      ),
                      Text(isSender ? receiverName : senderName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Project: ${widget.projectName}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        "Required: ${widget.skills.toString().substring(1).replaceAll("]", "")}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black)),
                  ),
                ],
              ),
              (!isSender && widget.status == "pending")
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () async {
                              await Invitations().acceptInvite(
                                  projectID: widget.ProjectID,
                                  ExistingProject: widget.existingProject,
                                  receiverSkills: widget.skills,
                                  inviteId: widget.inviteId,
                                  domain: widget.senderEmail
                                      .toString()
                                      .split("@")
                                      .last,
                                  projectName: widget.projectName,
                                  senderEmail: widget.senderEmail,
                                  receiverEmail: widget.receiverEmail);
                            },
                            child: Icon(
                              Icons.check_sharp,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Invitations().rejectInvite(
                                inviteId: widget.inviteId,
                                domain: widget.senderEmail
                                    .toString()
                                    .split("@")
                                    .last,
                                senderEmail: widget.senderEmail,
                                receiverEmail: widget.receiverEmail);
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.circle,
                                color: (widget.status == "accepted")
                                    ? Colors.green
                                    : (widget.status == "rejected")
                                        ? Colors.red
                                        : Colors.black,
                                size: 10,
                              ),
                            ),
                            Text("Status: ${widget.status}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
