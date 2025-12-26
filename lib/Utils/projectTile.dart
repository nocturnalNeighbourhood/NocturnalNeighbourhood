import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nocturnal/Functions/getUserData.dart';
import 'package:nocturnal/pages/ProjectDetailsPage.dart';

class Projecttile extends StatefulWidget {
  final String projectName;
  final String status;
  final String creator;
  final Map<String, dynamic> project;
  final String currentEmail;
  const Projecttile(
      {super.key,
      required this.projectName,
      required this.currentEmail,
      required this.status,
      required this.creator,
      required this.project});

  @override
  State<Projecttile> createState() => _ProjecttileState();
}

class _ProjecttileState extends State<Projecttile> {
  String creatorName = '';

  Future<void> getName(String userEmail) async {
    final Name = await Getuserdata.name(userEmail);
    if (!mounted) return;
    setState(() {
      creatorName = Name;
      //print("creator name : $creatorName");
    });
  }

  @override
  void initState() {
    super.initState();
    getName(widget.creator);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Projectdetailspage(
                  currentEmail: widget.currentEmail,
                  creatorEmail: widget.creator,
                  projectName: widget.projectName,
                  project: widget.project,
                  creator: creatorName,
                )));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.projectName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.circle,
                          color: (widget.status == "Ongoing")
                              ? Colors.black
                              : (widget.status == "Completed")
                                  ? Colors.green
                                  : Colors.red,
                          size: 10,
                        ),
                      ),
                      Text(
                        widget.status,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Creator : ${creatorName}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
