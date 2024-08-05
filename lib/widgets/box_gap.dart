import 'package:flutter/material.dart';
import '../app/constant.dart';

class BoxGap extends StatelessWidget {
  final double? height;
  final double? width;

  const BoxGap({super.key, this.height, this.width});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getActualY(y: height ?? 0, context: context),
      width: getActualX(x: width ?? 0, context: context),
    );
  }
}
