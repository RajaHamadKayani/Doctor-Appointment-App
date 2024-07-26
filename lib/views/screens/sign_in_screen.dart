import 'package:doctor_appointment_app/utils/app_colors.dart';
import 'package:doctor_appointment_app/view_model/forget_password_email_controller.dart';
import 'package:doctor_appointment_app/view_model/sign_in_controller.dart';
import 'package:doctor_appointment_app/views/screens/sign_up_screen.dart';
import 'package:doctor_appointment_app/views/widgets/authentication_dialog_box.dart';
import 'package:doctor_appointment_app/views/widgets/sign_in_screen_bottom_widget.dart';
import 'package:doctor_appointment_app/views/widgets/text_form_field_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  void _showDialogAndNavigate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AuthenticationDialogBox(
          title: "User signed in Successfully!",
          onDialogDismissed: () {},
        );
      },
    );
  }

  SignInController signInController = Get.put(SignInController());
  ForgetPasswordEmailController forgetPasswordEmailController =
      Get.put(ForgetPasswordEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, AppColors.gradient],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Welcome Back",
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "You can search course, apply course and find scholarship for abroad studies",
                    style: GoogleFonts.rubik(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormFieldComponent(
                      hintText: "Enter Email",
                      controller: signInController.emailController.value,
                    ),
                    const SizedBox(height: 20),
                    TextFormFieldComponent(
                      hintText: "Enter Password",
                      controller: signInController.passwordController.value,
                    ),
                    const SizedBox(height: 38),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          signInController
                              .login(
                            signInController.emailController.value.text,
                            signInController.passwordController.value.text,
                            context,
                          )
                              .then((userData) {
                            _showDialogAndNavigate();
                          });
                        },
                        child: Obx(() {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primaryColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: signInController.loading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Sign In",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          SignInScreenBottomWidget(
                            controller: forgetPasswordEmailController
                                .emailController.value,
                          ),
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0)),
                          ),
                        );
                      },
                      child: Text(
                        "Forget Password?",
                        style: GoogleFonts.rubik(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: Text(
                          "Don't have an account? Join us",
                          style: GoogleFonts.rubik(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
