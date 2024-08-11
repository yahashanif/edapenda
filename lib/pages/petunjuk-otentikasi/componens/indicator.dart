import 'package:dapenda/app/constant.dart';
import 'package:dapenda/themes/themes.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin:
          EdgeInsets.symmetric(horizontal: getActualX(x: 8, context: context)),
      height: 16.0,
      width: isActive ? 16.0 : 16.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: isActive ? green : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(28)),
      ),
    );
  }
}
