import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hiring_competition_app/backend/providers/auth_provider.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/views/applied_opportunities/empty.dart';
import 'package:hiring_competition_app/views/home/widgets/oppurtunities_card.dart';
import 'package:hiring_competition_app/views/home/widgets/oppurtunity_shimmer.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

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
    final provider = Provider.of<FirestoreProvider>(context);
    final authProvider = Provider.of<CustomAuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(category, style: TextStyle(color: const Color.fromARGB(255, 22, 22, 22))),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: provider.getUserStream(authProvider.user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return OppurtunityShimmer();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text("User not found");
                    }

                    final data = snapshot.data!.docs.first;
                    final batch = data["passedOutYear"];

                    return StreamBuilder(
                        stream: (category == "Internships")
                            ? provider.getInternships(batch)
                            : category == "Jobs"
                                ? provider.getJobs(batch)
                                : category == "Competitions"
                                    ? provider.getCompetitions(batch)
                                    : category == "Hackathons"
                                        ? provider.getHackathons(batch)
                                        : provider.getOpportunities(batch),
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
                            return Center(
                              child: Empty()
                            );
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
                                      companyName:
                                          doc["organization"] ?? "Company Name",
                                      category: doc["category"] ?? "category",
                                      eligibility:
                                          doc["eligibility"] ?? "Eligibility",
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
            ],
          ),
        ),
      ),
    );
  }
}
