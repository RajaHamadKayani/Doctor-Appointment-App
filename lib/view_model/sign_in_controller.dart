import 'package:doctor_appointment_app/services/authentication_services.dart';
import 'package:doctor_appointment_app/services/shared_preferences_helper.dart';
import 'package:doctor_appointment_app/views/screens/dashboard_screen.dart';
import 'package:doctor_appointment_app/views/screens/dashboard_screen_patient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  final isLoading = false.obs;
  bool get loading => isLoading.value;

  final AuthenticationService _authenticationService = Get.put(AuthenticationService());

 Future<void> login(String email, String password, BuildContext context) async {
  isLoading.value = true;
  var userData = await _authenticationService.login(email, password);

  if (userData != null) {
    isLoading.value = false;
    // Navigate to home screen and pass user data

    if(userData["uid"]!=null){
      SharedPreferencesHelper.storeuserId(userData["uid"]);
      SharedPreferencesHelper.storeUserRole(userData["role"]);
    }
    userData["role"]=="Admin"?   Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreenAdmin(userData: userData),
        ),
      ):   Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreenPatient(userData: userData),
        ),
      );

    emailController.value.clear();
    passwordController.value.clear();
  } else {
    isLoading.value = false;
    // Show error message
    Get.snackbar('Error', 'Failed to sign in', snackPosition: SnackPosition.BOTTOM);
  }
}

}
