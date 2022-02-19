import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImgLoadingShimmer extends StatelessWidget {
  const ImgLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      ),
    );
  }
}
