import 'package:doctor_appointment_app/views/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController extends GetxController {
  Future<void> signOut(BuildContext context) async {
    try {
      // Clear token from shared preferences
      await clearToken();

      // Navigate to login screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    print('Token cleared from shared preferences');
  }
}
