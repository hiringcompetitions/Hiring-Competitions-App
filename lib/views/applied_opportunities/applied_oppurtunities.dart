// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/applied_opportunities/applied_page_shimmer.dart';
import 'package:hiring_competition_app/views/applied_opportunities/empty.dart';
import 'package:hiring_competition_app/views/home/home_page.dart';
import 'package:hiring_competition_app/views/home/widgets/custom_drawer_button.dart';
import 'package:hiring_competition_app/views/home/widgets/oppurtunities_card.dart';
import 'package:provider/provider.dart';

class AppliedOppurtunities extends StatefulWidget {
  const AppliedOppurtunities({super.key});

  @override
  State<AppliedOppurtunities> createState() => _AppliedOppurtunitiesState();
}

class _AppliedOppurtunitiesState extends State<AppliedOppurtunities> {


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final firestoreProvider = Provider.of<FirestoreProvider>(context, listen: false);
      final authProvider = Provider.of<CustomAuthProvider>(context, listen: false);
      firestoreProvider.getAppliedOpportunityDetails(authProvider.user!.uid);
    });
  }

  String getTimeRemaining(Timestamp lastDate) {
    final deadline = lastDate.toDate();
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.inDays > 0) {
      return "${difference.inDays}d left";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h left";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}min left";
    } else {
      return "Expired";
    }
  }

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${date.day} ${months[date.month]} ${(date.year).toString().substring(2,4)}";
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final firestoreProvider = Provider.of<FirestoreProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              height: 150,
              padding: EdgeInsets.only(top: 24, left: 16),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2A37FF),
              ),
              child: Row(
                spacing: 6,
                children: [
                  Image.asset(
                    "lib/assets/images/icon.png",
                    height: 60,
                  ),
                  Text("Hiring\nCompetitions",
                      style: GoogleFonts.commissioner(
                        fontSize: 26,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            CustomDrawerButton(
              title: "Home",
              icon: "home",
              isActive: false,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            CustomDrawerButton(
              title: "Applied Opportunities",
              icon: "activity",
              isActive: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            CustomDrawerButton(
              title: "Profile",
              icon: "Profile_icon",
              isActive: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: firestoreProvider.isLoading
      ? AppliedPageShimmer()
      : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
            ),
        
            // Menu Drawer
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: CustomColors().blueShade,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "lib/assets/menu.png",
                    height: 30,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("Applied Oppurtunities", style: GoogleFonts.commissioner(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CustomColors().blackText,
              ),),
            ),
        
            // If Data is Null
            firestoreProvider.data == null
            ? Empty()
            : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: firestoreProvider.data?.length ?? 0,
              itemBuilder: (context, index) {
                final data = firestoreProvider.data?[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OppurtunitiesCard(
                      title: data?['title'] ?? '', 
                      companyName: data?['organization'] ?? '', 
                      eligibility: data?['eligibility'] ?? [], 
                      category: data?['category'] ?? '', 
                      place: data?['location'] ?? '', 
                      payout: data?['payout'] ?? '',
                      deadLine: getTimeRemaining(data?['lastdate']), 
                      index: index
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 22),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade100
                          ),
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: Row(
                          children: [
                            Text("Status : ", style: GoogleFonts.commissioner(
                              fontSize: 14,
                              color: Colors.grey.shade700
                            ),),
                            Text(data?['status'] ?? 'Status', style: GoogleFonts.commissioner(
                              fontSize: 14,
                              color: data?['status'] == 'Applied' ? Colors.grey.shade800 : data?['status'] == 'Selected' ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600
                            ),),
                            SizedBox(width: 10,),
                            Text("Applied On : ", style: GoogleFonts.commissioner(
                              fontSize: 14,
                              color: Colors.grey.shade700
                            ),),
                            Text( formatDate(data?['appliedOn']) , style: GoogleFonts.commissioner(
                              fontSize: 14,
                              color:Colors.grey.shade800,
                              fontWeight: FontWeight.w600
                            ),),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
