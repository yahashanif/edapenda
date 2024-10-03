import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'text-rapi.dart';

class DataUlangShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 24),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 150,
                      height: 50,
                      color: Colors.grey[300]!,
                    )),
              ),
              SizedBox(
                height: 32,
              ),
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
                  width: 40,
                  height: 13,
                  color: Colors.grey[300]!,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              ShimmerRapi(),
              ShimmerRapi(),
              ShimmerRapi(),
              ShimmerRapi(),
              ShimmerRapi(),
              ShimmerRapi(),
              SizedBox(
                height: 8,
              ),
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
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.grey[300]!)),
                ),
              ),
              SizedBox(
                height: 16,
              ),
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
                  margin: EdgeInsets.only(bottom: 8),
                  width: 65,
                  height: 10,
                  color: Colors.grey[300]!,
                ),
              ),
              SizedBox(
                height: 8,
              ),
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
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.grey[300]!)),
                ),
              ),
              SizedBox(
                height: 16,
              ),
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
                  margin: EdgeInsets.only(bottom: 8),
                  width: 65,
                  height: 10,
                  color: Colors.grey[300]!,
                ),
              ),
              SizedBox(
                height: 8,
              ),
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
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.grey[300]!)),
                ),
              ),
              SizedBox(
                height: 16,
              ),
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
                  margin: EdgeInsets.only(bottom: 8),
                  width: 65,
                  height: 10,
                  color: Colors.grey[300]!,
                ),
              ),
              SizedBox(
                height: 8,
              ),
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
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.grey[300]!)),
                ),
              ),
              SizedBox(
                height: 16,
              ),
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
                  margin: EdgeInsets.only(bottom: 8),
                  width: 65,
                  height: 10,
                  color: Colors.grey[300]!,
                ),
              ),
              SizedBox(
                height: 8,
              ),
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
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.grey[300]!)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
