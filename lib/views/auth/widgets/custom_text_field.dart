import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String image;
  const CustomTextField({
    required this.hintText,
    required this.image,  
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
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
              top: 7,
              bottom: 7,
              left: 16,
              right: 6,
            ),
            child: Image.asset("lib/assets/$image.png"),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(width: 2, color: CustomColors().blackText),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(width: 2, color: CustomColors().blackText),
          ),
        ),
      ),
    );
  }
}
