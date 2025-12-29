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
  String? pfp = "";

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

  Future<void> getPfp(String userEmail) async {
    final PFP = await Getuserdata.pfp(userEmail);
    if (!mounted) return;
    setState(() {
      pfp = PFP;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentEmail == widget.senderEmail) {
      getName(widget.receiverEmail, "receiver");
      getPfp(widget.receiverEmail);
    } else {
      getName(widget.senderEmail, "sender");
      getPfp(widget.senderEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSender = (widget.senderEmail == widget.currentEmail);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[600], borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 60,
                            height: 60,
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
                        Text(isSender ? receiverName : senderName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (!isSender && widget.status == "pending")
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.grey[850],
                                                title: Center(
                                                  child: Text(
                                                    "Are you sure you want to accept?",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                content: SizedBox(
                                                  height: 80,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                8),
                                                                    color: Colors
                                                                        .grey),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  child: Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await Invitations().acceptInvite(
                                                                  projectID: widget
                                                                      .ProjectID,
                                                                  ExistingProject:
                                                                      widget
                                                                          .existingProject,
                                                                  receiverSkills:
                                                                      widget
                                                                          .skills,
                                                                  inviteId: widget
                                                                      .inviteId,
                                                                  domain: widget
                                                                      .senderEmail
                                                                      .toString()
                                                                      .split(
                                                                          "@")
                                                                      .last,
                                                                  projectName:
                                                                      widget
                                                                          .projectName,
                                                                  senderEmail:
                                                                      widget
                                                                          .senderEmail,
                                                                  receiverEmail:
                                                                      widget
                                                                          .receiverEmail);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                8),
                                                                    color: Colors
                                                                        .black),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  child: Text(
                                                                    "Accept",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16),
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
                                      child: Icon(
                                        Icons.check_sharp,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.grey[850],
                                              title: Center(
                                                child: Text(
                                                  "Are you sure you want to reject?",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              content: SizedBox(
                                                height: 80,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: Colors
                                                                      .grey),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await Invitations().rejectInvite(
                                                                inviteId: widget
                                                                    .inviteId,
                                                                domain: widget
                                                                    .senderEmail
                                                                    .toString()
                                                                    .split("@")
                                                                    .last,
                                                                senderEmail: widget
                                                                    .senderEmail,
                                                                receiverEmail:
                                                                    widget
                                                                        .receiverEmail);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  color: Colors
                                                                      .black),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                child: Text(
                                                                  "Reject",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
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
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
