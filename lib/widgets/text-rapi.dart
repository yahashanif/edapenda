import 'package:dapenda/app/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../themes/themes.dart';

// ignore: must_be_immutable
class TextRapi extends StatelessWidget {
  String? data;
  String? value;

  TextRapi({super.key, this.data, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: getActualY(y: 8, context: context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              data ?? '',
              style: tahomaR.copyWith(
                fontSize: getActualY(y: 14, context: context),
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value ?? '',
                textAlign: TextAlign.end,
                style: tahomaR.copyWith(
                  fontSize: getActualY(y: 14, context: context),
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerRapi extends StatelessWidget {
  const ShimmerRapi({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Shimmer(
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
                  EdgeInsets.only(bottom: getActualY(y: 8, context: context)),
              width: 170,
              height: 10,
              color: Colors.grey[300]),
        ),
        Shimmer(
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
                  EdgeInsets.only(bottom: getActualY(y: 8, context: context)),
              width: getActualX(x: 90, context: context),
              height: getActualY(y: 10, context: context),
              color: Colors.grey[300]),
        ),
      ],
    );
  }
}
