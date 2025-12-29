import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> CreateUserData({
    required String domain,
    required String email,
    required String name,
    required String uid,
    required String pfp,
    required String phoneNumber,
    required String pass,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      FirebaseFirestore.instance
          .collection('users')
          .doc(domain)
          .collection('Details')
          .doc(email)
          .set({
        'name': name,
        'uid': uid,
        'pfp': pfp,
       
        'skills': [],
        'invitations': [],
        'phoneNumber': phoneNumber,
        'TimeStamp': Timestamp.now(),
      });
    } catch (e) {
      return;
    }
  }
}
