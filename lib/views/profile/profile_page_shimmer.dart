import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageShimmer extends StatelessWidget {
  const ProfilePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
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
            BuildShimmer(60, double.infinity),
            BuildShimmer(60, double.infinity),
            BuildShimmer(60, double.infinity),
            BuildShimmer(90, double.infinity),
          ],
        ),
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