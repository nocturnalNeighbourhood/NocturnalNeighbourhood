import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Invitations {
  Future<void> invite(
      bool existingProject,
      String? projectID,
      String toEmail,
      String fromEmail,
      String domain,
      List<String> reqSkills,
      String projectName) async {
    final inviteId = FirebaseFirestore.instance.collection('tmp').doc().id;
    final toRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(domain)
        .collection("Details")
        .doc(toEmail)
        .update({
      'invitations.$inviteId': {
        "existingProject": existingProject,
        "receiver": toEmail,
        "sender": fromEmail,
        "projectName": projectName,
        "status": "pending",
        "reqSkills": reqSkills,
        "projectID": existingProject ? projectID : "",
        "createdAt": FieldValue.serverTimestamp(),
      }
    });

    final fromRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(domain)
        .collection("Details")
        .doc(fromEmail)
        .update({
      'invitations.$inviteId': {
        "existingProject": existingProject,
        "receiver": toEmail,
        'sender': fromEmail,
        "projectName": projectName,
        "status": "pending",
        "reqSkills": reqSkills,
        "projectID": existingProject ? projectID : "",
        "createdAt": FieldValue.serverTimestamp(),
      }
    });
  }

  Future<void> acceptInvite({
    required String inviteId,
    required String domain,
    required String projectName,
    required String senderEmail,
    required String receiverEmail,
    required List<dynamic> receiverSkills,
    required String projectID,
    required bool ExistingProject,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final usersRef =
        firestore.collection("users").doc(domain).collection("Details");

    final senderRef = await usersRef.doc(senderEmail).get();

    final senderData = senderRef.data() as Map<String, dynamic>?;

    final senderPhone = await senderData!['phoneNumber'] as String;

    final receiverRef = await usersRef.doc(senderEmail).get();

    final receiverData = receiverRef.data() as Map<String, dynamic>?;

    final receiverPhone = await receiverData!['phoneNumber'] as String;

    DocumentReference<Map<String, dynamic>> projectRef =
        firestore.collection("projects").doc(inviteId);

    if (ExistingProject) {
      projectRef = firestore.collection("projects").doc(projectID);
      final batch = firestore.batch();
      batch.set(
        projectRef,
        {
          "UpdatedAt": FieldValue.serverTimestamp(),
          "members": {
            receiverEmail: {
              "role": "collaborator",
              "skills": receiverSkills,
              "phoneNumber": receiverPhone,
            },
          },
          "memberEmails": FieldValue.arrayUnion([receiverEmail]),
        },
        SetOptions(merge: true),
      );

      batch.update(usersRef.doc(senderEmail), {
        'invitations.$inviteId.status': 'accepted',
      });

      batch.update(usersRef.doc(receiverEmail), {
        'invitations.$inviteId.status': 'accepted',
      });

      await batch.commit();
    } else {
      final batch = firestore.batch();

      batch.set(
        projectRef,
        {
          "projectName": projectName,
          "createdAt": FieldValue.serverTimestamp(),
          "members": {
            senderEmail: {"role": "creator"},
            receiverEmail: {
              "role": "collaborator",
              "skills": receiverSkills,
              "phoneNumber": senderPhone,
            },
          },
          "memberEmails": [senderEmail, receiverEmail],
          "status": "Ongoing",
          "about": "",
        },
        SetOptions(merge: true),
      );

      batch.update(usersRef.doc(senderEmail), {
        'invitations.$inviteId.status': 'accepted',
      });

      batch.update(usersRef.doc(receiverEmail), {
        'invitations.$inviteId.status': 'accepted',
      });

      await batch.commit();
    }
  }

  Future<void> rejectInvite({
    required String inviteId,
    required String domain,
    required String senderEmail,
    required String receiverEmail,
  }) async {
    final usersRef = FirebaseFirestore.instance
        .collection("users")
        .doc(domain)
        .collection("Details");

    final batch = FirebaseFirestore.instance.batch();

    batch.update(usersRef.doc(senderEmail), {
      'invitations.$inviteId.status': 'rejected',
    });

    batch.update(usersRef.doc(receiverEmail), {
      'invitations.$inviteId.status': 'rejected',
    });

    await batch.commit();
  }
}
