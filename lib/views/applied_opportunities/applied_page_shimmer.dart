import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppliedPageShimmer extends StatelessWidget {
  const AppliedPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              SizedBox(height: 50,),
              BuildShimmer(60, 60, true),
              BuildShimmer(60, double.infinity, false),
              ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      BuildShimmer(130, double.infinity, false),
                      SizedBox(height: 12,),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildShimmer(double height,double width, bool isCircle) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, 
      highlightColor: Colors.grey.shade200,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isCircle ? BorderRadius.circular(1000) : BorderRadius.circular(20)
        ),
      ), 
    );
  }
}