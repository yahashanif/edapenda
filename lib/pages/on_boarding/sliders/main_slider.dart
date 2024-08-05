import 'package:flutter/material.dart';

import 'slide1.dart';
import 'slide2.dart';
import 'slide3.dart';

class MainSlider extends StatelessWidget {
  final int index;

  const MainSlider({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index == 0
          ? const Slide1()
          : index == 1
              ? const Slide2()
              : const Slide3(),
    );
  }
}
