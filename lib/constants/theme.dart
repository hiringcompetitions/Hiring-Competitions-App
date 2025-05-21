import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';

ThemeData getApptheme(){
  return ThemeData(
    textTheme: TextTheme(
      displayLarge: GoogleFonts.koulen(
              fontSize: 48,
              color: CustomColors().blackText,
              fontWeight: FontWeight.w500,
            ),
      displayMedium: GoogleFonts.koulen(
              fontSize: 34,
              color: CustomColors().blackText,
              fontWeight: FontWeight.w500,           
      ),
      displaySmall: GoogleFonts.koulen(
               fontSize: 26,
              color: CustomColors().blackText,
              fontWeight: FontWeight.w500,
      ),
      headlineLarge: GoogleFonts.commissioner(
              fontSize: 26,
              color: CustomColors().blackText,
              
      ),
      headlineMedium: GoogleFonts.commissioner(
              fontSize: 20,
              color: CustomColors().blackText,
      ),
      headlineSmall: GoogleFonts.commissioner(
              fontSize: 18,
              color: CustomColors().blackText,
              fontWeight: FontWeight.w600,
      ),
      
      labelLarge: GoogleFonts.commissioner(
              fontSize: 18,
              color: CustomColors().greyText,
              
      ),
      labelMedium: GoogleFonts.commissioner(
              fontSize: 16,
              color: CustomColors().greyText,
      ),
      labelSmall: GoogleFonts.commissioner(
              fontSize: 12,
              color: CustomColors().greyText,
      ),
       titleLarge: GoogleFonts.commissioner(
              fontSize: 22,
              color: CustomColors().white,           
      ),
      titleMedium: GoogleFonts.commissioner(
              fontSize: 14,
              color: CustomColors().white,
      ),
      titleSmall: GoogleFonts.commissioner(
              fontSize: 12,
              color: CustomColors().white,
      ),
    ) 
  );
}