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

  static Future<String> phoneNumber(String userEmail) async {
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

    if (data == null || !data.containsKey('phoneNumber')) return "";

    String phoneNumber = data['phoneNumber'] as String;

    return phoneNumber;
  }

  static Future<String> pfp(String userEmail) async {
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

    if (data == null || !data.containsKey('pfp')) return "";

    String name = data['pfp'] as String;

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

    if (data == null || !data.containsKey('about')) return "";

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

  Stream<QuerySnapshot>? usersNamesStream(String userName) {
    if (userName.isEmpty) return null;

    final user = FirebaseAuth.instance.currentUser!;
    final domain = user.email!.split('@').last;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(domain)
        .collection('Details')
        .orderBy('name')
        .startAt([userName]).endAt([userName + '\uf8ff']).snapshots();
  }

  Future<int> getPendingInvitationsCount(
    String domain,
    String userEmail,
  ) async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(domain)
        .collection("Details")
        .doc(userEmail)
        .get();

    if (!doc.exists) return 0;

    final data = doc.data();
    if (data == null || data['invitations'] == null) return 0;

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

    return invitationList
        .where((invite) =>
            invite['status'] == 'pending' && invite['receiver'] == userEmail)
        .length;
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

      DateTime getTime(dynamic value) {
        if (value is Timestamp) return value.toDate();
        if (value is int) {
          return DateTime.fromMillisecondsSinceEpoch(value);
        }
        if (value is String) {
          return DateTime.tryParse(value) ?? DateTime(0);
        }
        return DateTime(0);
      }

      invitationList.sort((a, b) {
        DateTime aTime = getTime(a['createdAt']);
        DateTime bTime = getTime(b['createdAt']);
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

  Stream<int> getProjectsCount(String userEmail) {
    return FirebaseFirestore.instance
        .collection('projects')
        .where('memberEmails', arrayContains: userEmail)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.length;
    });
  }

  Future<int> getNyx(String userEmail) async {
    int Nyx = 0;
    final snapShot = await FirebaseFirestore.instance
        .collection('projects')
        .where('memberEmails', arrayContains: userEmail)
        .get();

    for (var doc in snapShot.docs) {
      final data = doc.data();

      final status = data['status'];

      if (status == "Ongoing") {
        Nyx += 150;
      } else if (status == "Completed") {
        Nyx += 300;
      } else if (status == "Cancelled") {
        Nyx += 80;
      } else {
        Nyx += 50;
      }
    }

    return Nyx;
  }
}
