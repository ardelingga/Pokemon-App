import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ContentShimmer extends StatelessWidget {
  const ContentShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, i) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
            ),
          );
        }, childCount: 10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 4 / 3,
        ),
      ),
    );
  }
}
