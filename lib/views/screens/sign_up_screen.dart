import 'dart:io';
import 'package:doctor_appointment_app/utils/app_colors.dart';
import 'package:doctor_appointment_app/view_model/sign_up_controller.dart';
import 'package:doctor_appointment_app/views/screens/sign_in_screen.dart';
import 'package:doctor_appointment_app/views/widgets/authentication_dialog_box.dart';
import 'package:doctor_appointment_app/views/widgets/text_form_field_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedRole = "Admin";
  File? selectedGalleryIamge;
  Future getGalleryImage() async {
    final returedIamge = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      selectedGalleryIamge = File(returedIamge!.path);
    });
  }

  Future getCameraImage() async {
    final returedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      selectedGalleryIamge = File(returedImage!.path);
    });
  }

  Widget dialogBox(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Pick Image",
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "Take Image from either gallery or camera",
        style: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                getGalleryImage();
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(color: AppColors.primaryColor),
                child: Center(
                  child: Text(
                    "Gallery",
                    style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                getCameraImage();
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(color: AppColors.primaryColor),
                child: Center(
                  child: Text(
                    "Camera",
                    style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  SignUpController signUpController = Get.put(SignUpController());

  void _showDialogAndNavigate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AuthenticationDialogBox(
          title: "User registered Successfully!",
          onDialogDismissed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
              (Route<dynamic> route) => false,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                AppColors.gradient,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "Join us to start searching",
                    style: GoogleFonts.rubik(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "You can search c ourse, apply course and find scholarship for abroad studies",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: dialogBox);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: AppColors.primaryColor),
                          shape: BoxShape.circle),
                      height: 150,
                      width: 150,
                      child: selectedGalleryIamge == null
                          ? Center(
                              child: Text(
                                "Select Image",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.cover,
                              child: CircleAvatar(
                                backgroundImage: selectedGalleryIamge != null
                                    ? FileImage(
                                        File(selectedGalleryIamge!.path))
                                    : null,
                              ),
                            ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextFormFieldComponent(
                        hintText: "Enter Email",
                        controller: signUpController.emailController.value,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldComponent(
                        hintText: "Enter Password",
                        controller: signUpController.passwordController.value,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldComponent(
                        hintText: "Enter Name",
                        controller: signUpController.nameController.value,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: DropdownButtonFormField<String>(
                            value: selectedRole,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Quantity",
                              hintStyle: GoogleFonts.montserrat(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                            ),
                            items: <String>["Admin", "Patient"]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.montserrat(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedRole = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 38,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(() {
                          return GestureDetector(
                            onTap: () {
                              signUpController
                                  .signUp(
                                      context,
                                      signUpController
                                          .emailController.value.text,
                                      signUpController
                                          .passwordController.value.text,
                                      signUpController
                                          .nameController.value.text,
                                      selectedGalleryIamge!.path,
                                      selectedRole)
                                  .then((value) {
                                _showDialogAndNavigate();
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.primaryColor),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: signUpController.loading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "Sign Up",
                                          style: GoogleFonts.rubik(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Have an account? Log in",
                            style: GoogleFonts.rubik(
                                color: AppColors.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
