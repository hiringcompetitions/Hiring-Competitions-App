import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';
import 'package:hiring_competition_app/views/webView/web_view_page.dart';

class BottomButtons extends StatelessWidget {
  final String mainButton;
  final String secondButton;
  final String url;
  final String title;
  final void Function()? secondFunction;
  const BottomButtons({
    required this.mainButton,
    required this.secondButton,
    required this.secondFunction,
    required this.url,
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainButton == 'Selected' || mainButton == 'Applied' ? const Color.fromARGB(255, 12, 139, 16) : CustomColors().darkBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: () {
              mainButton == "Apply Now"
              ? Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: url, title: title)))
              : ();
            },
            child: Text(mainButton,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white)),
          ),
        ),

        // Applied? Button

        secondButton != ""
        ? GestureDetector(
          onTap: secondFunction,
          child: Container(
            height: 52,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(36)),
            child: Text(
              secondButton,
              style: GoogleFonts.commissioner(
                fontSize: 16,
                color: CustomColors().blackText,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
        ) : SizedBox.shrink()
      ],
    );
  }
}
