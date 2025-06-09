import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        spacing: 24,
        children: [
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BuildShimmer(60, 60),
              BuildShimmer(60, 60),
            ],
          ),
          BuildShimmer(160, double.infinity),
          BuildShimmer(60, double.infinity),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BuildShimmer(180, MediaQuery.of(context).size.width / 2 - 30),
              BuildShimmer(180, MediaQuery.of(context).size.width / 2 - 30),
            ],
          ),
          BuildShimmer(90, double.infinity),
        ],
      ),
    );
  }

  Widget BuildShimmer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}