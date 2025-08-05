// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings, unused_local_variable

import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/models/user_model.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/error_toast.dart';
import 'package:hiring_competition_app/views/auth/widgets/custom_text_field.dart';
import 'package:hiring_competition_app/views/home/home_page.dart';
import 'package:provider/provider.dart';

class OtherInfoPage extends StatefulWidget {
  OtherInfoPage({super.key});

  @override
  State<OtherInfoPage> createState() => _OtherInfoPageState();
}

class _OtherInfoPageState extends State<OtherInfoPage> {
  TextEditingController _nameController = TextEditingController();
  String? gender = 'Select Gender';

  List<String> options = ["Select Gender","Male", "Female"];

  String? getPassedOutYear(String? rollNo) {
    // 23PA1A0577
    if(rollNo == null) return null;
    try {
      if(rollNo.toLowerCase().contains("pa1a")) {
        return "20"+(int.parse(rollNo.substring(0,2)) + 4).toString();
      } else {
        return "20"+(int.parse(rollNo.substring(0,2)) + 3).toString();
      }
    } catch(e) {
      errorToast("Please Enter your college mail id", context);
      return "";
    }
  }

  String? getBranch(String? rollNo) {
    Map<String, String> branches = {
      "01" : "CIVIL",
      "02" : "EEE",
      "03" : "MECH",
      "04" : "ECE",
      "05" : "CSE",
      "12" : "IT",
      "42" : "AIML",
      "45" : "AIDS",
      "57" : "CSBS",
    };

    if(rollNo == null) return null;
    return branches[rollNo.substring(6,8)];
  }

  Future<void> addUser(String gender, String nickName) async {
    try {
      if(gender == 'Select Gender') {
        errorToast("Please select Gender", context);
        return;
      }
      final authProvider = Provider.of<CustomAuthProvider>(context, listen: false);
      final firestoreProvider = Provider.of<FirestoreProvider>(context, listen: false);

      final fcmToken = await firestoreProvider.getFcmToken();
      final passedOutYear = getPassedOutYear(authProvider.user?.email?.substring(0,10));
      final branch = getBranch(authProvider.user?.email?.substring(0,10));

      UserModel user = UserModel(
                        name: authProvider.user?.displayName ?? 'No Name',
                        nickName: nickName,
                        rollNo: authProvider.user?.email?.substring(0, 10) ?? 'No Email',
                        branch: branch ?? 'No Branch',
                        passedOutYear: passedOutYear ?? 'No PassedOutYear', 
                        email: authProvider.user?.email ?? 'No Email', 
                        gender: gender,
                        uid: authProvider.user?.uid ?? 'No UID',
                        fcmtoken: fcmToken ?? 'No FCM token',
                      );

      final res = await firestoreProvider.addUser(user);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
    } catch(e) {
      errorToast(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirestoreProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors().white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),

            // Headings
            Text(
              "More about you",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text("We just need a few more details to complete your profile.",
                style: Theme.of(context).textTheme.labelLarge),
            SizedBox(height: 20),

            // Name
            CustomTextField(
              hintText: "Nick Name",
              image: "user",
              controller: _nameController,
            ),
            SizedBox(
              height: 14,
            ),

            // Gender
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: CustomColors().darkBlue,
                ),
                borderRadius: BorderRadius.circular(100)
              ),
              child: Row(
                spacing: 12,
                children: [
                  Image.asset("lib/assets/user.png", height: 28,),
                  DropdownButton<String>(
                    style: GoogleFonts.commissioner(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: CustomColors().greyText,
                    ),
                    elevation: 0,
                    value: gender,
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                    items: options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14,),

            // Continue Button
            GestureDetector(
              onTap: () {
                addUser(gender ?? 'Select Gender', _nameController.text);
              },
              child: Container(
                alignment: Alignment(0, 0),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: CustomColors().darkBlue),
                child: provider.isLoading!
                    ? Container(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          color: CustomColors().white,
                          strokeWidth: 3,
                        ))
                    : Text("Continue",
                        style: GoogleFonts.commissioner(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: CustomColors().white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}