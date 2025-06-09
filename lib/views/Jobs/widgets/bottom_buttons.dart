import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';

class BottomButtons extends StatelessWidget {
  final String mainButton;
  final String secondButton;
  final void Function()? mainFunction;
  final void Function()? secondFunction;
  const BottomButtons({
    required this.mainButton,
    required this.secondButton,
    required this.mainFunction,
    required this.secondFunction,
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
            onPressed: mainFunction,
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
