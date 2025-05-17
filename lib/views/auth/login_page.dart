import 'package:flutter/material.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/views/auth/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors().white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal : 26.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),

            // Headings
            Text("WELCOME BACK!", style: GoogleFonts.koulen(
              fontSize: 34,
              color: CustomColors().blackText,
              fontWeight: FontWeight.w500,
            )),
            Text("Login to continue your journey", style: GoogleFonts.commissioner(
              color: CustomColors().greyText,
              fontSize : 16,
            ),),

            SizedBox(height: 20),

            // Email
            CustomTextField(hintText: "Email", image: "email",),
            SizedBox(height: 10,),

            // Password
            CustomTextField(hintText: "Password", image: "password",),
            SizedBox(height: 10,),

            // Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children : [Text("Forgot password ?", style: GoogleFonts.commissioner(fontSize: 14, color: CustomColors().blackText),)])
          ],
        ),
      ),
    );
  }
}