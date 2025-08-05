import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _passedOutYearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirestoreProvider>(context, listen: false);
    final authProvider = Provider.of<CustomAuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: CustomColors().darkBlue,
      body: StreamBuilder(
        stream: provider.getUserStream(authProvider.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.commissioner(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }

          final data = snapshot.data;
          if (data != null && data.docs.isNotEmpty) {
            final doc = data.docs.first;
            
            // Populate controllers with existing data
            _nickNameController.text = doc['nickName'] ?? '';
            _nameController.text = doc['name'] ?? '';
            _rollNoController.text = doc['rollNo'] ?? '';
            _emailController.text = doc['email'] ?? '';
            _branchController.text = doc['branch'] ?? '';
            _passedOutYearController.text = doc['passedOutYear'] ?? '';

            return Stack(
              children: [
                // Back Button
                Positioned(
                  top: 50,
                  left: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ),

                // Edit Profile Form
                Positioned(
                  top: 120,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    height: MediaQuery.of(context).size.height - 130,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40),
                          
                          // Profile Avatar
                          Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: AvatarPlus(
                                doc['nickName'] ?? 'User',
                                trBackground: true,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 30),
                          
                          BuildEditField('Nick Name', _nickNameController),
                          BuildEditField('Name', _nameController),
                          BuildEditField('Roll No', _rollNoController),
                          BuildEditField('Email', _emailController),
                          BuildEditField('Branch', _branchController),
                          BuildEditField('Passed Out Year', _passedOutYearController, isNumber: true),
                          
                          SizedBox(height: 20),
                          
                          // Save Changes Button
                          GestureDetector(
                            onTap: () {
                              // Save profile changes
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CustomColors().darkBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Save Changes',
                                    style: GoogleFonts.commissioner(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(Icons.save, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 14),
                          
                          // Cancel Button
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: CustomColors().darkBlue,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Cancel',
                                    style: GoogleFonts.commissioner(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: CustomColors().darkBlue,
                                    ),
                                  ),
                                  Icon(Icons.cancel, color: CustomColors().darkBlue, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Center(
            child: Text(
              'No user data found',
              style: GoogleFonts.commissioner(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget BuildEditField(String title, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.commissioner(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.commissioner(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CustomColors().blackText,
          ),
          decoration: InputDecoration(
            hintText: 'Enter $title',
            hintStyle: GoogleFonts.commissioner(
              fontSize: 16,
              color: Colors.grey.shade400,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: CustomColors().darkBlue, width: 2),
            ),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}