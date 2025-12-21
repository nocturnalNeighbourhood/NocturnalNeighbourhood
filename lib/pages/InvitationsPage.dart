import 'package:flutter/material.dart';
import 'package:nocturnal/Utils/InvitationTile.dart';

class Invitationspage extends StatefulWidget {
  const Invitationspage({super.key});

  @override
  State<Invitationspage> createState() => _InvitationspageState();
}

class _InvitationspageState extends State<Invitationspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Invitations",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Invitationtile(
            name: "Vishnu Vardhan",
          ),
          Invitationtile(
            name: "TonyStark",
          ),
        ],
      ),
    );
  }
}
