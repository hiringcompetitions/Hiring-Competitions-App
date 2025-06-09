// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/views/Jobs/Job_info.dart';

import '../../../constants/custom_colors.dart';

class OppurtunitiesCard extends StatelessWidget {
  final String title;
  final String companyName;
  final List<dynamic> eligibility;
  final String category;
  final String place;
  final String payout;
  final String deadLine;
  final int index;

  OppurtunitiesCard({
    required this.title,
    required this.companyName,
    required this.eligibility,
    required this.category,
    required this.place,
    required this.payout,
    required this.deadLine,
    required this.index,
    super.key
  });

  List<Color> colors = [
    CustomColors().purple,
    CustomColors().blue,
    Colors.red,
    const Color.fromARGB(255, 0, 184, 6),
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => JobInfo(eventName: title, logoColor: colors[index%5],)));
        },
        child: Container(
            height: 132,
            padding: EdgeInsets.only(bottom: 16),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 244, 244, 244),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top : 16.0, right: 16, left: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 14,
                    children: [
                  
                      // Logo
                      Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors[index % 5],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          companyName.substring(0,1),
                          style: GoogleFonts.merriweather(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                  
                      // Title and Company Name
                  
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                  
                            Text(
                              title,
                              style: GoogleFonts.commissioner(
                                fontSize: 20,
                                color: CustomColors().blackText,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                  
                            // Company Name & Eligibility
                  
                            Container(
                              width: 230,
                              child: Text(
                                "$companyName | Eligibility : ${eligibility.join(', ')}",
                                style: GoogleFonts.commissioner(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: CustomColors().greyText,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
        
                // Labels
        
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(width: 10),
                      Label(category, ""),
                      place != "" ? Label(place, "location") : SizedBox.shrink(),
                      payout != "" ? Label(payout, "payout") : SizedBox.shrink(),
                      Label(deadLine, "time1"),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget Label(String title, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: image != "time1" ? Colors.white : CustomColors().darkBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          spacing: 6,
          children: [
            image != "" ? Image.asset("lib/assets/$image.png", height: 14,) : SizedBox.shrink(),
            Text(title,
                style: GoogleFonts.commissioner(
                    fontSize: 13,
                    color: image == "time1" ? CustomColors().white : CustomColors().blackText,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
