// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_const_constructors_in_immutables

import 'package:avatar_plus/avatar_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/backend/providers/notification_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/main.dart';
import 'package:hiring_competition_app/views/Jobs/Job_info.dart';
import 'package:hiring_competition_app/views/applied_opportunities/applied_oppurtunities.dart';
import 'package:hiring_competition_app/views/home/widgets/category_page.dart';
import 'package:hiring_competition_app/views/home/widgets/custom_drawer_button.dart';
import 'package:hiring_competition_app/views/home/widgets/home_page_shimmer.dart';
import 'package:hiring_competition_app/views/home/widgets/oppurtunities_card.dart';
import 'package:hiring_competition_app/views/home/widgets/oppurtunity_shimmer.dart';
import 'package:hiring_competition_app/views/home/widgets/search_page.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_card.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_errorCard.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_shimmer.dart';
import 'package:hiring_competition_app/views/home/widgets/viewall_page.dart';
import 'package:hiring_competition_app/views/notifications/notifications_page.dart';
import 'package:hiring_competition_app/views/onboarding/onboarding.dart';
import 'package:hiring_competition_app/views/onboarding/widgets/onboard_template.dart';
import 'package:hiring_competition_app/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void setupNotificationHandling(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      storeNotification(message);
      _handleNavigationFromNotification(message, context);
    });

    // Handle notification from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        storeNotification(message);
        _handleNavigationFromNotification(message, context);
      }
    });
  }

  void _handleNavigationFromNotification(
      RemoteMessage message, BuildContext context) {
    final data = message.data;
    final screen = data['screen'];

    if (screen == 'jobInfo') {
      final name = data['name'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  JobInfo(logoColor: Colors.purple, eventName: name)));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  void logout() {
    final authProvider = Provider.of<CustomAuthProvider>(context, listen: false);
    authProvider.signout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FirestoreProvider>(context, listen: false);
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    Future.microtask(() async {
      final authProvider =
          Provider.of<CustomAuthProvider>(context, listen: false);
      provider.getNickName(authProvider.user);
      notificationProvider.listen();
      provider.getUserDetails(authProvider.user?.uid ?? 'null');
      notificationProvider
          .subscribeToTopic(provider.userDetails?['passedOutYear'] ?? '');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        storeNotification(message);
        // _handleNavigationFromNotification(message, context);
      });

      setupNotificationHandling(context);
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

  List<Map<String, dynamic>> categories = [
    {
      "name": "Jobs",
      "image": "lib/assets/images/jobs.png",
      "height": 70.0,
      "width": 70.0,
      "onTap": () {},
    },
    {
      "name": "Internships",
      "image": "lib/assets/images/internships.png",
      "height": 90.0,
      "width": 90,
    },
    {
      "name": "Hackathons",
      "image": "lib/assets/images/hackathon.png",
      "height": 70,
      "width": 70,
    },
    {
      "name": "Competitions",
      "image": "lib/assets/images/competitions.png",
      "height": 70,
      "width": 70,
    },
  ];

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppliedOppurtunities()));
                  },
                ),
                CustomDrawerButton(
                  title: "Profile",
                  icon: "Profile_icon",
                  isActive: false,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                ),
              ],
            ),
            Column(
              children: [
                CustomDrawerButton(
                  title: "Logout",
                  icon: "logout",
                  isActive: false,
                  onTap: logout,
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: provider.isLoading
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
                                        builder: (context) =>
                                            NotificationsPage()));
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
                      style: GoogleFonts.poppins(
                        fontSize: 20,
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));
                      },
                      child: Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 22),
                              height: 48,
                              decoration: BoxDecoration(
                                  color: CustomColors().blueShade,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Search for Opportunities",
                                    style: GoogleFonts.commissioner(
                                      color: CustomColors().greyText,
                                      fontSize: 16,
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
                  ),
                  SizedBox(
                    height: 26,
                  ),

                  // Categories

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "CATEGORIES",
                                style: GoogleFonts.commissioner(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors().blackText,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 6),
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: SizedBox(
                      height: 106,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap : () {
                              if (index == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryPage(category: "Jobs")));
                              } else if (index == 1) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryPage(category: "Internships")));
                              } else if (index == 2) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryPage(category: "Hackathons")));
                              } else if (index == 3) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryPage(category: "Competitions")));
                              } else if (index == 2) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewallPage(TopPick: false)));
                              } else if (index == 3) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewallPage(TopPick: false)));
                              }
                            },
                            child: Container(
                              width: 120,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 221, 221, 221),
                                  width: 1
                                ),
                              ),
                              child: Stack(
                                children: [
                            
                                  Positioned(
                                    bottom: -190,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                    height: 220,
                                    width: 620,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color.fromARGB(255, 239, 244, 255),
                                          Colors.white.withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                  )),
                            
                                  Positioned(
                                    top: 12,
                                    left: 0,
                                    right: 0,
                                    child: Text(categories[index]['name'].toUpperCase(), 
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(255, 55, 55, 55),
                                        )),
                                  ),
                              
                                  Positioned(
                                    bottom: -12,
                                    left: 0,
                                    right: 0,
                                    child: Image.asset(
                                      categories[index]['image'],
                                      height: 75,
                                      width:75,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Top Picks Heading

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "TOP PICKS",
                                style: GoogleFonts.commissioner(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: CustomColors().blackText,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 6),
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewallPage(
                                          TopPick: true,
                                        )));
                          },
                          child: Text("View all",
                              style: GoogleFonts.commissioner(
                                fontSize: 12,
                                color: CustomColors().greyText,
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 6),

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
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "LATEST OPPORTUNITIES",
                                style: GoogleFonts.commissioner(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors().blackText,
                                  letterSpacing: 1.4,
                                ),
                              ),
                          
                              SizedBox(
                                width: 6,
                              ), 
                          
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 6),
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [

                            SizedBox(
                              width: 16,
                            ),

                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewallPage(TopPick: false)));
                              },
                              child: Text("View all",
                                  style: GoogleFonts.commissioner(
                                    fontSize: 12,
                                    color: CustomColors().greyText,
                                  )),
                            ),
                          ],
                        )
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
                              debugPrint(
                                  "Data length: ${data!.docs.length}");

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

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewallPage(TopPick: false)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      "Push beyond\nLimits".toUpperCase(),
                      style: GoogleFonts.anton(
                          fontSize: 48,
                          color: Colors.grey.shade200,
                          height: 1.1),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Text(
                      "Made with ❤️ for Vishnu",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade800,
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
