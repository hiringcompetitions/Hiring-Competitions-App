import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/onboarding/onboarding.dart';
import 'package:hiring_competition_app/views/profile/profile_page_shimmer.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirestoreProvider>(context, listen: false);
    final authProvider =
        Provider.of<CustomAuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 68, 171, 255),
      body: StreamBuilder(
          stream: provider.getUserStream(authProvider.user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ProfilePageShimmer();
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data;

            if (data != null && data.docs.isNotEmpty) {
              final doc = data.docs.first;

              return Stack(children: [
                // Red Circle
                Positioned(
                  top: -150,
                  left: -250,
                  child: Container(
                    height: 450,
                    width: 450,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 99, 88),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Yellow Circle

                Positioned(
                  top: 50,
                  right: -120,
                  child: Container(
                    height: 350,
                    width: 350,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 225, 78),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

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
                        color: const Color.fromARGB(50, 0, 0, 0),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),

                // Profile Details

                Positioned(
                  top: 150,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    height: MediaQuery.of(context).size.height - 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 60),
                          BuildProfileDetail('Nick Name', doc['nickName'] ?? 'N/A'),
                          BuildProfileDetail('Name', doc['name'] ?? 'N/A'),
                          BuildProfileDetail('Roll No', doc['rollNo'] ?? 'N/A'),
                          BuildProfileDetail('Email', doc['email'] ?? 'N/A'),
                          BuildProfileDetail('Branch', doc['branch'] ?? 'N/A'),
                          BuildProfileDetail('Passed Out Year', doc['passedOutYear'] ?? 'N/A'),
                          GestureDetector(
                            onTap: () {
                              // Navigate to Change Password Page
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
                                    'Change Password',
                                    style: GoogleFonts.commissioner(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(Icons.lock_open_rounded,
                                      color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 14),
                          GestureDetector(
                            onTap: () {
                              authProvider.signout();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
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
                                    'Logout',
                                    style: GoogleFonts.commissioner(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: CustomColors().darkBlue,
                                    ),
                                  ),
                                  Icon(Icons.logout,
                                      color: CustomColors().darkBlue, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Profile Image
                Positioned(
                    top: 100,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: Container(
                      height: 100,
                      width: 100,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: AvatarPlus(
                        doc['nickName'] ?? 'N/A',
                        trBackground: true,
                      ),
                    )),

                // Edit Profile Button
                Positioned(
                  top: 170,
                  left: MediaQuery.of(context).size.width / 2 + 20,
                  child: InkWell(
                    onTap: () {
                      // Navigate to Edit Profile Page
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CustomColors().darkBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ]);
            }

            return Center(
              child: Text(
                'No user data found',
                style: GoogleFonts.commissioner(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            );
          }),
    );
  }

  Widget BuildProfileDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.commissioner(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.commissioner(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: CustomColors().blackText),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
