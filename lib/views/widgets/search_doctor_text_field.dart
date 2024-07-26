import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SearchDoctorTextField extends StatefulWidget {
  TextEditingController controller;
  String hintText;

  SearchDoctorTextField({super.key, required this.controller, required this.hintText});

  @override
  State<SearchDoctorTextField> createState() => _SearchDoctorTextFieldState();
}

class _SearchDoctorTextFieldState extends State<SearchDoctorTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xffffffff),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
          style: GoogleFonts.rubik(
            color: Color(0xff677294),
            fontWeight: FontWeight.w300,
          ),
          controller: widget.controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search_outlined,
              color: Color(0xff677294),
            ),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.rubik(
              color: Color(0xff677294),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
