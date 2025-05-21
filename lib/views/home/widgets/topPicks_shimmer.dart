import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ToppicksShimmer extends StatelessWidget {
  const ToppicksShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0
                ? const EdgeInsets.only(left: 20.0, right: 8)
                : const EdgeInsets.only(right: 8),
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFE6E6E6),
              highlightColor: const Color(0xFFEFEFEF),
              child: Container(
                height: 240,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
