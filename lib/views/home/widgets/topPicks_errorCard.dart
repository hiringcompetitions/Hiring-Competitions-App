import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToppicksErrorcard extends StatelessWidget {
  const ToppicksErrorcard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        alignment: Alignment.center,
        height: 230,
        width: MediaQuery.of(context).size.width - 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("lib/assets/images/error.png", height: 110,),
            Text("OOps!", style: GoogleFonts.commissioner(
              fontSize: 20,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500
            ),),
            Text("nothing found here...", style: GoogleFonts.commissioner(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400
            ),)
          ],
        ),
      ),
    );
  }
}