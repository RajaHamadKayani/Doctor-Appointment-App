import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageServices {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(String imagePath, String uid) async {
    File file = File(imagePath);
    try {
      TaskSnapshot snapshot = await firebaseStorage
          .ref()
          .child('user_images')
          .child('image_$uid.jpg')
          .putFile(file);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if(kDebugMode){
              print('Error uploading image: $e');

      }
      throw e;
    }
  }
}
