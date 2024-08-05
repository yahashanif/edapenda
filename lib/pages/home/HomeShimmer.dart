import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 10, top: 16, right: 10, bottom: 16),
        child: Column(
          children: [
            Shimmer(
              direction: ShimmerDirection.ltr,
              gradient: LinearGradient(
                stops: [0.2, 0.5, 0.8],
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[300]!.withOpacity(0.4),
                  Colors.grey[300]!
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 24),
            Shimmer(
              direction: ShimmerDirection.ltr,
              gradient: LinearGradient(
                stops: [0.2, 0.5, 0.8],
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[300]!.withOpacity(0.4),
                  Colors.grey[300]!
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 135,
                color: Colors.grey[300]!,
              ),
            ),
            SizedBox(height: 10),
            Shimmer(
              direction: ShimmerDirection.ltr,
              gradient: LinearGradient(
                stops: [0.2, 0.5, 0.8],
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[300]!.withOpacity(0.4),
                  Colors.grey[300]!
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey[300]!,
              ),
            ),
            SizedBox(height: 10),
            Shimmer(
              direction: ShimmerDirection.ltr,
              gradient: LinearGradient(
                stops: [0.2, 0.5, 0.8],
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[300]!.withOpacity(0.4),
                  Colors.grey[300]!
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey[300]!,
              ),
            ),
            SizedBox(height: 10),
            Shimmer(
              direction: ShimmerDirection.ltr,
              gradient: LinearGradient(
                stops: [0.2, 0.5, 0.8],
                colors: [
                  Colors.grey[300]!,
                  Colors.grey[300]!.withOpacity(0.4),
                  Colors.grey[300]!
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey[300]!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: LinearGradient(
        stops: [0.2, 0.5, 0.8],
        colors: [
          Colors.grey[300]!,
          Colors.grey[300]!.withOpacity(0.4),
          Colors.grey[300]!
        ],
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: 10,
        color: Colors.grey[300]!,
      ),
    );
  }
}

class TextShimmer2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: LinearGradient(
        stops: [0.2, 0.5, 0.8],
        colors: [
          Colors.grey[300]!,
          Colors.grey[300]!.withOpacity(0.4),
          Colors.grey[300]!
        ],
      ),
      child: Container(
        width: double.infinity,
        height: 24,
        color: Colors.grey[300]!,
      ),
    );
  }
}

class FotoShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: LinearGradient(
        stops: [0.2, 0.5, 0.8],
        colors: [
          Colors.grey[300]!,
          Colors.grey[300]!.withOpacity(0.4),
          Colors.grey[300]!
        ],
      ),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[300]!,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
