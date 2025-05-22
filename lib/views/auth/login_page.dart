// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/error_toast.dart';
import 'package:hiring_competition_app/views/auth/other_info_page.dart';
import 'package:hiring_competition_app/views/auth/signup_page.dart';
import 'package:hiring_competition_app/views/auth/widgets/custom_text_field.dart';
import 'package:hiring_competition_app/views/home/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  void loginValidator(String email, String password, BuildContext context) async {
    final provider = Provider.of<CustomAuthProvider>(context, listen: false);
    if(email == "" || password == "") {
      errorToast("Please enter the required credentials", context);
    } else if(!email.contains("@vishnu.edu.in")) {
      errorToast("Please enter your college email", context);
    } else {
      final msg = await provider.login(email, password);
      if(msg != null) {
        errorToast(msg, context);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  void googleLogin(BuildContext context) async {
    final provider = Provider.of<CustomAuthProvider>(context, listen: false);
    final res = await provider.googleLogin();

    if(res != null) {
      errorToast(res, context);
    } else {
      print("Successs");
      errorToast("Login Success", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtherInfoPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomAuthProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors().white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal : 20.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),

            // Headings
            Text("WELCOME BACK!", style: Theme.of(context).textTheme.displayMedium,),
            Text("Login to continue your journey", style: Theme.of(context).textTheme.labelLarge
            ),

            SizedBox(height: 20),

            // Email
            CustomTextField(hintText: "Email", image: "email", controller: _emailController,),
            SizedBox(height: 14,),

            // Password
            CustomTextField(hintText: "Password", image: "password", controller: _passwordController,),
            SizedBox(height: 10,),

            // Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children : [Text("Forgot password ?", style:Theme.of(context).textTheme.labelMedium)]
            ),
            SizedBox(height: 20,),

            // Login Button
            GestureDetector(
              onTap: () {
                provider.isLoading! ? null :
                loginValidator(_emailController.text, _passwordController.text, context);
              },
              child: Container(
                alignment: Alignment(0, 0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: CustomColors().darkBlue
                ),
                child: provider.isLoading!
                  ? Container(height : 23,width: 23 ,child : CircularProgressIndicator(color: CustomColors().white, strokeWidth: 3,)) 
                  : Text("Login", style: GoogleFonts.commissioner(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors().white)),
              ),
            ),
            SizedBox(height: 16,),

            // Create account label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account ? ", style: Theme.of(context).textTheme.labelMedium,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text("Create Account", style: GoogleFonts.commissioner(fontSize: 13, fontWeight: FontWeight.w600))),
              ],
            ),
            SizedBox(height: 40,),

            // OR label
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Expanded(child: Divider()),
                Text("or", style: Theme.of(context).textTheme.labelMedium,),
                Expanded(child: Divider())
              ],
            ),
            SizedBox(height: 40,),


            // Google Signin
            GestureDetector(
              onTap: () {
                googleLogin(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: CustomColors().darkBlue,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Image.asset("lib/assets/google.jpg", height: 35,),
                    Text("Continue with google", style: GoogleFonts.commissioner(fontSize: 16, fontWeight: FontWeight.w400, color: CustomColors().blackText)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}