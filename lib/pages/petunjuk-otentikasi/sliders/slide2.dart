import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../app/constant.dart';
import '../../../themes/themes.dart';
import '../../../widgets/box_gap.dart';

class Slide2 extends StatelessWidget {
  const Slide2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxGap(
            height: defaultMargin,
          ),
          Center(
            child: SvgPicture.asset(
              'assets/svg/tegak_camera.svg',
              width: getActualX(x: 400, context: context),
            ),
          ),
          const BoxGap(
            height: 70,
          ),
          Text(
              "Hadapkan wajah kedepan kamera dan pastikan berada di tempat terang",
              textAlign: TextAlign.center,
              style: tahomaR.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
