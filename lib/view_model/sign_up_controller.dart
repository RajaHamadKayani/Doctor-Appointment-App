import 'package:doctor_appointment_app/services/authentication_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SignUpController extends GetxController {
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  final isLoading = false.obs;
  bool get loading => isLoading.value;

  AuthenticationService authenticationService = Get.put(AuthenticationService());

  Future<void> signUp(BuildContext context, String email, String password,
      String name, String imagePath, String selectedRole) async {
    isLoading.value = true;
    bool success = await authenticationService.registerWithEmailAndPassword(
        email: email,
        role: selectedRole,
        name: name,
        password: password,
        image: imagePath);
    if (success) {
      isLoading.value = false;
      nameController.value.clear();
      passwordController.value.clear();
      emailController.value.clear();
     
    } else {
      isLoading.value = false;
      Get.snackbar("Sign Up", "Failed", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
