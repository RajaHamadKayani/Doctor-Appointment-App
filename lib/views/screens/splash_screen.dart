import 'dart:async';

import 'package:doctor_appointment_app/services/firestore_services.dart';
import 'package:doctor_appointment_app/services/shared_preferences_helper.dart';
import 'package:doctor_appointment_app/views/screens/dashboard_screen.dart';
import 'package:doctor_appointment_app/views/screens/dashboard_screen_patient.dart';
import 'package:doctor_appointment_app/views/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    final FirestoreServices firestoreServices = Get.put(FirestoreServices());
   
   late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Cancel the timer to prevent accessing the disposed context
    super.dispose();
  }

  void startTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }
  
  void checkLoginStatus() async {
  String? token = await SharedPreferencesHelper.getUid();
  String? role = await SharedPreferencesHelper.getUserRole();
  if (token != null) {
    // Fetch user data
    Map<String, dynamic>? userData = await firestoreServices.getUserCredentials(token);
    if (userData != null) {
      role == "Admin"
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreenAdmin(userData: userData)))
          : Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreenPatient(userData: userData)));
    } else {
      // Handle case where userData is null
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
}


 
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SvgPicture.asset("assets/svgs/splash.svg"),
        ),
      ),
    );
  }
}