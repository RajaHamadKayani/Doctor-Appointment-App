import 'package:doctor_appointment_app/utils/app_colors.dart';
import 'package:doctor_appointment_app/views/widgets/text_form_field_component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SignInScreenBottomWidget extends StatefulWidget {
  dynamic controller;
   SignInScreenBottomWidget({super.key,this.controller});

  @override
  State<SignInScreenBottomWidget> createState() => _SignInScreenBottomWidgetState();
}

class _SignInScreenBottomWidgetState extends State<SignInScreenBottomWidget> {
  @override
  Widget build(BuildContext context) {
    return   SizedBox(
     
      child: Padding(
        padding: const EdgeInsets.all(19),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text("Forgot password",
             style: GoogleFonts.rubik(color: Colors.black,
             fontWeight: FontWeight.w600,
             fontSize: 24),),
             Text("Enter your email for the verification proccesss,we will send 4 digits code to your email.",
          style:    GoogleFonts.rubik(color: Colors.black,
             fontWeight: FontWeight.w300,
             fontSize: 14),),
             const SizedBox(height: 36,),
             TextFormFieldComponent(
              hintText: "Enter your email",
             ),
             const SizedBox(height: 30,),
               Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryColor
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text("Login",style: GoogleFonts.rubik(color: Colors.white),),
                          ),
                        ),
                      ),),
            ],
          ),
        ),
      ),
    );
  }
}