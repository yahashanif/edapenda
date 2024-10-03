import 'package:dapenda/app/constant.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../themes/themes.dart';

class Slide1 extends StatelessWidget {
  const Slide1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BoxGap(
            height: defaultMargin,
          ),
          Center(
            child: SvgPicture.asset(
              'assets/svg/dont_masker.svg',
              width: getActualX(x: 400, context: context),
            ),
          ),
          const BoxGap(
            height: 70,
          ),
          Text(
              "Kenakan Pakaian Sopan, serta pastikan wajah tak tertutup apapun, seperti masker dan kacamata",
              textAlign: TextAlign.center,
              style: tahomaR.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
