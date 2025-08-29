import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiring_competition_app/constants/custom_colors.dart';

class BottomButtons extends StatelessWidget {
  final String mainButton;
  final String secondButton;
  final void Function()? mainFunction;
  final void Function()? secondFunction;
  final bool isButtonEnabled;

  const BottomButtons({
    required this.mainButton,
    required this.secondButton,
    this.mainFunction,
    this.secondFunction,
    this.isButtonEnabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    if (mainButton.toLowerCase() == 'selected') {
      buttonColor = Colors.green;
    } else if (mainButton.toLowerCase() == 'rejected') {
      buttonColor = Colors.red;
    } else {
      buttonColor = CustomColors().darkBlue;
    }

    // Always use the same color, even when disabled
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      disabledBackgroundColor: buttonColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              style: buttonStyle,
              onPressed: isButtonEnabled ? mainFunction : null,
              child: Text(
                mainButton,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        if (secondButton.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: secondFunction,
              child: Container(
                height: 52,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(36)),
                child: Text(
                  secondButton,
                  style: GoogleFonts.commissioner(
                      fontSize: 16,
                      color: CustomColors().blackText,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
      ],
    );
  }
}