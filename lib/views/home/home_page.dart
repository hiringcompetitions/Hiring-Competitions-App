// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'package:avatar_plus/avatar_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/backend/providers/notification_provider.dart';
import 'package:hiring_competition_app/backend/services/auth_services.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/applied_opportunities/applied_oppurtunities.dart';
import 'package:hiring_competition_app/views/home/widgets/custom_drawer_button.dart';
import 'package:hiring_competition_app/views/home/widgets/home_page_shimmer.dart';
import 'package:hiring_competition_app/views/home/widgets/oppurtunities_card.dart';
import 'package:hiring_competition_app/views/home/widgets/oppurtunity_shimmer.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_card.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_errorCard.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_shimmer.dart';
import 'package:hiring_competition_app/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FirestoreProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    Future.microtask(() {
      final authProvider =
          Provider.of<CustomAuthProvider>(context, listen: false);
          provider.getNickName(authProvider.user);
          notificationProvider.listen();
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

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final provider = Provider.of<FirestoreProvider>(context);
    final authProvider = Provider.of<CustomAuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
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
              isActive: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            CustomDrawerButton(
              title: "Applied Opportunities",
              icon: "activity",
              isActive: false,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AppliedOppurtunities()));
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
      body: SingleChildScrollView(
        child: provider.isLoading!
            ? HomePageShimmer()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),

                  // Menu Drawer and Profile

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
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
                        Row(
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
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
                                  "lib/assets/notifications.png",
                                  height: 24,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: CustomColors().blueShade,
                                  shape: BoxShape.circle,
                                ),
                                child: AvatarPlus(provider.name ?? "random",
                                    trBackground: true, height: 50, width: 50),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),

                  // Welcome Text

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Hey ${provider.name} 👋,\nOppurtunities are Waiting",
                      style: GoogleFonts.commissioner(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: CustomColors().blackText,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Search Bar

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 26),
                            height: 48,
                            decoration: BoxDecoration(
                                color: CustomColors().blueShade,
                                borderRadius: BorderRadius.circular(100)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Search",
                                  style: GoogleFonts.commissioner(
                                    color: CustomColors().greyText,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: CustomColors().darkBlue,
                                borderRadius: BorderRadius.circular(100)),
                            child: Image.asset(
                              "lib/assets/search.png",
                              height: 20,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 26,
                  ),

                  // Top Picks Heading

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Top Picks",
                          style: GoogleFonts.commissioner(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: CustomColors().blackText,
                          ),
                        ),
                        Text("View all",
                            style: GoogleFonts.commissioner(
                              fontSize: 12,
                              color: CustomColors().greyText,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: 14),

                  // Top Picks List

                  StreamBuilder(
                      stream: provider.getUserStream(authProvider.user!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ToppicksShimmer();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text("User not found");
                        }

                        final data = snapshot.data!.docs.first;
                        final batch = data["passedOutYear"];

                        return StreamBuilder(
                            stream: provider.getTopPicks(batch),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Error : ${snapshot.error}");
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ToppicksShimmer();
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return ToppicksErrorcard();
                              }

                              final data = snapshot.data;

                              if (data != null) {
                                return SizedBox(
                                  height: 230,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: data.docs.length,
                                      itemBuilder: (context, index) {
                                        final doc = data.docs[index];
                                        return TopPicksCard(
                                          index: index,
                                          companyName: doc["organization"],
                                          title: doc["title"],
                                          eligibility: doc["eligibility"],
                                        );
                                      }),
                                );
                              }

                              return Container();
                            });
                      }),
                  SizedBox(
                    height: 16,
                  ),

                  // Latest Oppurtunities Heading

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Latest Oppurtunities",
                          style: GoogleFonts.commissioner(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: CustomColors().blackText,
                          ),
                        ),
                        Text("View all",
                            style: GoogleFonts.commissioner(
                              fontSize: 12,
                              color: CustomColors().greyText,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),

                  // Latest Oppurtunities
                  StreamBuilder(
                      stream: provider.getUserStream(authProvider.user!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ToppicksShimmer();
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text("User not found");
                        }

                        final data = snapshot.data!.docs.first;
                        final batch = data["passedOutYear"];

                        return StreamBuilder(
                            stream: provider.getOpportunities(batch),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("err");
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return OppurtunityShimmer();
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Text("No data");
                              }

                              final data = snapshot.data;

                              if (data != null) {
                                return ListView.builder(
                                    itemCount: data.docs.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(0),
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final doc = data.docs[index];
                                      return OppurtunitiesCard(
                                          title: doc["title"] ?? "Name",
                                          companyName: doc["organization"] ??
                                              "Company Name",
                                          category:
                                              doc["category"] ?? "category",
                                          eligibility: doc["eligibility"] ??
                                              "Eligibility",
                                          payout: doc["payout"] ?? 'Payout',
                                          deadLine:
                                              getTimeRemaining(doc["lastdate"]),
                                          place: doc["location"] ?? "Place",
                                          index: index);
                                    });
                              }

                              return Text("err2");
                            });
                      }),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "     View All",
                            style: GoogleFonts.commissioner(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: CustomColors().blackText,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CustomColors().darkBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_outward_sharp,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
      ),
    );
  }
}
