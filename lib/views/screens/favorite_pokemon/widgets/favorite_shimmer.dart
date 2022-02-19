import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteShimmer extends StatelessWidget {
  const FavoriteShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, i) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
