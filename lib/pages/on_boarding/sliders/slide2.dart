import 'package:flutter/material.dart';

import '../../../app/constant.dart';
import '../../../themes/themes.dart';
import '../../../widgets/box_gap.dart';

class Slide2 extends StatelessWidget {
  const Slide2({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: getActualY(y: 8, context: context),
                top: getActualY(y: 48, context: context),
                right: getActualX(x: 8, context: context)),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.39,
            color: const Color(0XFF63B4C9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'OTENTIKASI WAJAH',
                  style: tahomaB.copyWith(
                    fontSize: getActualY(y: 30, context: context),
                    color: Colors.white,
                  ),
                ),
                const BoxGap(
                  height: 24,
                ),
                Text(
                  'Ambil swa foto / selfie\nuntuk identifikasi wajah Anda',
                  textAlign: TextAlign.center,
                  style: tahomaR.copyWith(
                    fontSize: getActualY(y: 24, context: context),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/slide2.png'),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
