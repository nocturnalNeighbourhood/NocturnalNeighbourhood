import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Getuserdata {
  static Future<String> name(String userEmail) async {
    final user = FirebaseAuth.instance.currentUser!;
    final domain = user.email!.split('@').last;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(domain)
        .collection('Details')
        .doc(userEmail);

    final snapshot = await userRef.get();

    if (!snapshot.exists) return "loading..";

    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null || !data.containsKey('name')) return "no name";

    String name = data['name'] as String;

    return name;
  }

  static Future<String> about(String userEmail) async {
    final user = FirebaseAuth.instance.currentUser!;
    final domain = user.email!.split('@').last;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(domain)
        .collection('Details')
        .doc(userEmail);

    final snapshot = await userRef.get();

    if (!snapshot.exists) return "loading..";

    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null || !data.containsKey('about')) return "..";

    String about = data['about'] as String;

    return about;
  }

  Stream<QuerySnapshot>? usersWithSkillStream(List<String> skills) {
    if (skills.isEmpty) return null;

    final user = FirebaseAuth.instance.currentUser!;
    final domain = user.email!.split('@').last;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(domain)
        .collection('Details')
        .where('skills', arrayContainsAny: skills)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> invitationsChannel(
    String domain,
    String userEmail,
  ) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(domain)
        .collection("Details")
        .doc(userEmail.toLowerCase().trim())
        .snapshots()
        .map((doc) {
      //print("hello reached");

      if (!doc.exists) return [];

      final data = doc.data();
      if (data == null || data['invitations'] == null) {
        //print("heyo reached");
        return [];
      }

      //print("end reached");

      final invitations = data['invitations'];

      List<Map<String, dynamic>> invitationList = [];

      if (invitations is List) {
        invitationList =
            invitations.map((e) => Map<String, dynamic>.from(e)).toList();
      }

      if (invitations is Map) {
        invitationList = invitations.entries.map((e) {
          return {
            'id': e.key,
            ...Map<String, dynamic>.from(e.value),
          };
        }).toList();
      }

      invitationList.sort((a, b) {
        final aTime = a['createdAt'] as Timestamp?;
        final bTime = b['createdAt'] as Timestamp?;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });

      return invitationList;
    });
  }

  Stream<List<Map<String, dynamic>>> displayProjects(String userEmail) {
    return FirebaseFirestore.instance
        .collection('projects')
        .where('memberEmails', arrayContains: userEmail)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    });
  }
}
