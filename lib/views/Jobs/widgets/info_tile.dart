// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InfoTile extends StatelessWidget {
  String image;
  String text;
  InfoTile({required this.image, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return text != ""
        ? IntrinsicWidth(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/assets/$image.png",
                    height: 16,
                  ),
                  SizedBox(width: 7),
                  Text(text, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
