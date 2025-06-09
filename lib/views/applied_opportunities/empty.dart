import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
          Center(child: Image.asset("lib/assets/images/error.png", height: 150,)),
          SizedBox(height: 10,),
          Center(
            child: Text("Nothing to show here...", style: GoogleFonts.commissioner(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w300
            ),),
          ),
          SizedBox(height: 10,),
          Center(child: Text("Explore", style: GoogleFonts.commissioner(
            fontSize: 20,
            color: CustomColors().darkBlue,
            fontWeight: FontWeight.w600
          ),),)
        ],
      );
  }
}