// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/Jobs/Job_info.dart';

class TopPicksCard extends StatelessWidget {
  final int index;
  final String companyName;
  final String title;
  final List<dynamic> eligibility;
  TopPicksCard({
    required this.index,
    required this.companyName,
    required this.title,
    required this.eligibility,
    super.key
  });

  List<List<Color>> colors = [
    [CustomColors().skyblue, Colors.white60, CustomColors().white],
    [CustomColors().yellow, Colors.black54, CustomColors().blackText],
    [CustomColors().purple, Colors.white60, CustomColors().white],
    [CustomColors().green, Colors.black54, CustomColors().blackText],
    [CustomColors().red, Colors.white60, CustomColors().white],
    [CustomColors().pink, Colors.black54, CustomColors().blackText],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: index == 0
          ? const EdgeInsets.only(top: 8.0, right: 12, left: 20)
          : const EdgeInsets.only(top: 8.0, right: 12, left: 0),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>JobInfo(logoColor: colors[index%5][0], eventName: title)));
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
              color: colors[index % 6][0],
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company Logo and Name
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        companyName.substring(0,1).toUpperCase(),
                        style: GoogleFonts.commissioner(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: colors[index % 6][2]),
                      ),
                    ),
                    Text(
                      companyName,
                      style: GoogleFonts.commissioner(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: colors[index % 6][2],
                        ),
                    )
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
        
                // Title of the oppurtunity
                Container(
                  height: 62,
                  child: Text(
                    title.length < 24 ? title : title.substring(0, 20) + "...",
                    style: GoogleFonts.commissioner(
                      fontSize: 26,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                      color: colors[index % 6][2],
                    ),
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
        
                // Eligibility
        
                Text(
                  "Eligibility : ${eligibility.join(', ')}",
                  style: GoogleFonts.commissioner(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors[index % 6][1]),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 14,
                ),
        
                // Apply button
                Row(
                  spacing: 6,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: colors[index % 6][2],
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Apply Now",
                          style: GoogleFonts.commissioner(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors[index % 6][0],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors[index % 6][2],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_sharp,
                        color: colors[index % 6][0],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
