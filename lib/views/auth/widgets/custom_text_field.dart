import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String image;
  final TextEditingController controller;
  const CustomTextField({
    required this.hintText,
    required this.image,  
    required this.controller,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.commissioner(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.commissioner(
          fontSize: 18,
          color: CustomColors().greyText,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 16,
            right: 10,
          ),
          child: Image.asset("lib/assets/$image.png", height: 8,),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(width: 2, color: CustomColors().blackText),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(width: 2, color: CustomColors().blackText),
        ),
      ),
    );
  }
}
