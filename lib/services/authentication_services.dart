import 'package:doctor_appointment_app/services/firebase_storage_services.dart';
import 'package:doctor_appointment_app/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationService {
  final FirestoreServices firestoreServices = Get.put(FirestoreServices());
  final FirebaseStorageServices firebaseStorageServices = Get.put(FirebaseStorageServices());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String role,
    required String name,
    required String image,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String imageUrl = await firebaseStorageServices.uploadImage(
          image, userCredential.user!.uid);
      await firestoreServices.storingUserCredentials(userCredential.user!.uid,
          email, password, name, imageUrl, role);
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

 Future<Map<String, dynamic>?> login(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return await firestoreServices.getUserCredentials(userCredential.user!.uid);
  } catch (e) {
    print('Error during login: $e');
    return null;
  }
}

  

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
