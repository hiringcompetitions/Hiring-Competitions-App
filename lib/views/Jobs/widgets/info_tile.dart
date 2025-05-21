import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  IconData icon;
  String text;
  InfoTile({
    required this.icon,
    required this.text,
    super.key});


 @override
Widget build(BuildContext context) {
  return IntrinsicWidth(
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 7),
          Text(text, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    ),
  );
}

}