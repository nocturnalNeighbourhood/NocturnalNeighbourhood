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


  

  
}
