import 'package:avatar_plus/avatar_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/backend/services/firebase_services/auth_services.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/home/widgets/oppurtunities_card.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_card.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_shimmer.dart';
import 'package:hiring_competition_app/views/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({required this.user, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<FirestoreProvider>(context, listen: false);
      provider.getNickName(widget.user);
      provider.getTopPicks();
    });
  }

  final List<Map<String, String>> opportunities = [
    {
      "title": "Google STEP Internship",
      "companyName": "Google",
      "eligibility": "26, 27",
      "category": "Internship",
      "place": "Hyderabad",
      "payout": "80K",
      "deadLine": "10d left",
    },
    {
      "title": "Flutter Developer Hiring",
      "companyName": "TCS Digital",
      "eligibility": "25, 26",
      "category": "Job",
      "place": "Remote",
      "payout": "7L",
      "deadLine": "5d left",
    },
    {
      "title": "Techathon 5.0",
      "companyName": "Microsoft",
      "eligibility": "26, 27, 28",
      "category": "Hackathon",
      "place": "Online",
      "payout": "1L",
      "deadLine": "15d left",
    },
    {
      "title": "UI Design Sprint",
      "companyName": "Adobe",
      "eligibility": "26, 27, 28",
      "category": "Challenge",
      "place": "Online",
      "payout": "20K",
      "deadLine": "7d left",
    },
    {
      "title": "Code Rush Hiring",
      "companyName": "Infosys",
      "eligibility": "25, 26",
      "category": "Job",
      "place": "Pune",
      "payout": "6.5L",
      "deadLine": "1M left",
    },
  ];


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirestoreProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                  Container(
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
                stream: provider.topPicksSnapshots,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ToppicksShimmer();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No data");
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
                              companyName: doc["companyName"],
                              title: doc["title"],
                              eligibility: doc["eligibility"],
                            );
                          }),
                    );
                  }
                  return Container();
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

            ListView.builder(
                itemCount: opportunities.length,
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = opportunities[index];
                  return OppurtunitiesCard(
                    title: data["title"] ?? "Title",
                    companyName: data["companyName"] ?? "Company Name",
                    category: data["category"] ?? "category",
                    eligibility: data["eligibility"] ?? "Eligibility",
                    payout: data["payout"] ?? 'Payout',
                    deadLine: data["deadLine"] ?? "Deadline",
                    place: data["place"] ?? "Place",
                    index : index
                  );
                }),
          ],
        ),
      ),
    );
  }
}
