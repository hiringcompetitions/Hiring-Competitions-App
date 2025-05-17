import 'package:flutter/material.dart';


class OnboardTemplate extends StatelessWidget {
  Color color;
  Color textcolor;
  String title;
  String description;
  String image;
   OnboardTemplate({
    required this.textcolor,
    required this.color,
    required this.image,
    required this.title,
    required this.description,
    super.key});

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.all(25),
      height:size.height ,
      width: size.width,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("lib/assets/images/${image}.png",),
          SizedBox(height: 10,),
          Text(title,style: Theme.of(context).textTheme.displayLarge?.copyWith(color: textcolor),),
          SizedBox(height: 10,),
          SizedBox(
            width: size.width*0.8,
            child: Text(description,style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: textcolor),))
        ],
      ),
    );
  }
}