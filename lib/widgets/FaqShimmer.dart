import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../app/constant.dart';

class FaqShimmer extends StatelessWidget {
  const FaqShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: LinearGradient(
        stops: const [0.2, 0.5, 0.8],
        colors: [
          Colors.grey[300]!,
          Colors.grey[300]!.withOpacity(0.4),
          Colors.grey[300]!
        ],
      ),
      child: Container(
        margin:
            EdgeInsets.symmetric(vertical: getActualY(y: 4, context: context)),
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
