// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/error_toast.dart';
import 'package:hiring_competition_app/views/auth/other_info_page.dart';
import 'package:hiring_competition_app/views/auth/widgets/custom_text_field.dart';
import 'package:hiring_competition_app/views/home/home_page.dart';
import 'package:hiring_competition_app/views/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  SignupPage({super.key});

  void signupValidator(String name, String email, String password, BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    if(email == "" || password == "" || name == "") {
      errorToast("Please enter the required credentials", context);
    } else if(!email.contains("@vishnu.edu.in") || !email.toLowerCase().contains("pa")) {
      errorToast("Please enter your college email", context);
    } else {
      final msg = await provider.createAccount(email, password, name);
      if(msg != null) {
        errorToast(msg, context);
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtherInfoPage()));
      }
    }
  }

  void googleLogin(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
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
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors().white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal : 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
        
              // Headings
              Text("Create Account", style: Theme.of(context).textTheme.displayMedium,),
              Text("Join and start competing today", style: Theme.of(context).textTheme.labelLarge
              ),
              SizedBox(height: 20),
        
              // Name
              CustomTextField(hintText: "Full Name", image: "user", controller: _nameController,),
              SizedBox(height: 14,),
        
              // Email
              CustomTextField(hintText: "Email", image: "email", controller: _emailController,),
              SizedBox(height: 14,),
        
              // Password
              CustomTextField(hintText: "Password", image: "password", controller: _passwordController,),
              SizedBox(height: 14,),
        
              // Signup Button
              GestureDetector(
                onTap: () {
                  provider.isLoading! ? null :
                  signupValidator( _nameController.text.trim(),_emailController.text.trim(), _passwordController.text.trim(), context);
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
                    : Text("Create Account", style: GoogleFonts.commissioner(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors().white)),
                ),
              ),
              SizedBox(height: 16,),
        
              // Create account label
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ? ", style: Theme.of(context).textTheme.labelMedium,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Login", style: GoogleFonts.commissioner(fontSize: 13, fontWeight: FontWeight.w600))),
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
      ),
    );
  }
}