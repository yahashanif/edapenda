import 'package:flutter/material.dart';

import 'slide1.dart';
import 'slide2.dart';

class MainSliderPetunjuk extends StatelessWidget {
  final int index;

  const MainSliderPetunjuk({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index == 0 ? const Slide1() : const Slide2(),
    );
  }
}
