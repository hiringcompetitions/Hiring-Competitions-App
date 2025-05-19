import 'package:avatar_plus/avatar_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/backend/providers/firestore_provider.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/home/widgets/topPicks_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({
    required this.user,
    super.key
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<FirestoreProvider>(context, listen: false);
    provider.getNickName(widget.user);
    provider.getTopPicks();
    renameCollection();
  }

  void renameCollection() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final oldCollection = firestore.collection('Top Picks');
    final newCollection = firestore.collection('TopPicks');

    final snapshot = await oldCollection.get();

    for (var doc in snapshot.docs) {
      await newCollection.doc(doc.id).set(doc.data());
      await oldCollection.doc(doc.id).delete(); // optional: only if you want to remove old collection
    }

    print("Collection renamed successfully.");
  }

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
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: CustomColors().blueShade,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset("lib/assets/menu.png", height: 30,),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: CustomColors().blueShade,
                      shape: BoxShape.circle,
                    ),
                    child: AvatarPlus( provider.name ?? "random",
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
                "Hey ${provider.name},\nOppurtunities are Waiting",
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
                    child: Image.asset("lib/assets/search.png", height: 20,)
                  ),
                ],
              ),
            ),
            SizedBox(height: 26,),
                
            // Top Picks Heading
                
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text("Top Picks", style: GoogleFonts.commissioner(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: CustomColors().blackText,
                ),),
                Text("View all", style : GoogleFonts.commissioner(
                  fontSize: 12,
                  color: CustomColors().greyText,
                ))
              ],),
            ),
            SizedBox(height: 14),
                
            // Top Picks List

            StreamBuilder(
              stream: provider.topPicksSnapshots, 
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if(!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Container(child: Text("No data"),);
                }

                final data = snapshot.data;

                if(data != null) {
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
                      }
                    ),
                  );
                }
                return Container();
              }
            ),
          ],
        ),
      ),
    );
  }
}
