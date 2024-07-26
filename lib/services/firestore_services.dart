import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> storingUserCredentials(
    String uid,
    String email,
    String password,
    String name,
    String imageUrl,
    String selectedRole,
  ) async {
    await firebaseFirestore.collection("users").doc(uid).set({
      "name": name,
      "email": email,
      "password": password,
      "imageUrl": imageUrl,
      "role": selectedRole
    });
  }

  Future<Map<String, dynamic>?> getUserCredentials(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await firebaseFirestore.collection("users").doc(uid).get();
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        data['uid'] = uid; // Include UID in the data
        return data;
      } else {
        if (kDebugMode) {
          print("Error during fetching data");
        }

        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("error during fetching user credentials: $e");
      }
      return null;
    }
  }

  // Function to add a doctor
  Future<void> addDoctor({
    required String adminId,
    required String name,
    required String specialization,
    required String experience,
    required String imageUrl,
  }) async {
    await firebaseFirestore
        .collection('admins')
        .doc(adminId)
        .collection('doctors')
        .add({
      'name': name,
      'specialization': specialization,
      'experience': experience,
      'imageUrl': imageUrl,
    });
  }

  // Function to fetch doctors for a specific admin
  Future<List<Map<String, dynamic>>> fetchDoctors(String adminId) async {
    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('admins')
          .doc(adminId)
          .collection('doctors')
          .get();
      List<Map<String, dynamic>> doctors = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return doctors;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching doctors: $e");
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllDoctors() async {
    List<Map<String, dynamic>> allDoctors = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Fetch all admin documents
      QuerySnapshot adminSnapshot = await firestore.collection('admins').get();
      if (kDebugMode) {
        print('Admin count: ${adminSnapshot.docs.length}');
      }
      if (adminSnapshot.docs.isEmpty) {
        if (kDebugMode) {
          print('No admins found.');
        }
      }

    for (var adminDoc in adminSnapshot.docs) {
    print('Admin ID: ${adminDoc.id}');
    String adminId = adminDoc.id;

    // Fetch the doctors subcollection for each admin
    QuerySnapshot doctorSnapshot = await firestore
        .collection('admins')
        .doc(adminId)
        .collection('doctors')
        .get();

    print('Doctor count for admin $adminId: ${doctorSnapshot.docs.length}');

    for (var doctorDoc in doctorSnapshot.docs) {
        var data = doctorDoc.data();
        print('Doctor data: $data');

        if (data != null && data is Map<String, dynamic>) {
            allDoctors.add({
                'name': data['name'] ?? '',
                'imageUrl': data['imageUrl'] ?? '',
                'experience': data['experience'] ?? '',
                'specialization': data['specialization'] ?? '',
            });
        } else {
            print('Invalid or null data for doctor: ${doctorDoc.id}');
        }
    }
}

      if (kDebugMode) {
        print("All doctors fetched: $allDoctors");
      }
      return allDoctors;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching doctors: $e");
      }
      return [];
    }
  }

  Future<void> testFetch() async {
    try {
      QuerySnapshot snapshot =
          await firebaseFirestore.collection('admins').get();
      if (kDebugMode) {
        print('Admins: ${snapshot.docs.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching admins: $e");
      }
    }
  }
}
