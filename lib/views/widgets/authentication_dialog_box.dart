import 'package:doctor_appointment_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticationDialogBox extends StatefulWidget {
  final String title;
  final VoidCallback onDialogDismissed;

 const  AuthenticationDialogBox({
    super.key,
    required this.title,
    required this.onDialogDismissed,
  });

  @override
  State<AuthenticationDialogBox> createState() =>
      _AuthenticationDialogBoxState();
}

class _AuthenticationDialogBoxState extends State<AuthenticationDialogBox> {
  @override
  Widget build(BuildContext context) {
    // Determine the height of the screen
    final screenHeight = MediaQuery.of(context).size.height;
    // Set the desired height for the dialog box (half the height of the screen)
    final dialogHeight = screenHeight * 0.5;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: dialogHeight,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Authentication Alert!",
              style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Icon(
                    Icons.done,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                widget.onDialogDismissed();
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    "Ok",
                    style: GoogleFonts.rubik(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
