import 'package:dapenda/app/constant.dart';
import 'package:flutter/material.dart';

import '../../../themes/themes.dart';
import '../../../widgets/box_gap.dart';

class Slide3 extends StatelessWidget {
  const Slide3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: getActualX(x: 8, context: context),
              top: getActualY(y: 48, context: context),
              right: getActualX(x: 8, context: context)),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.39,
          color: const Color(0XFF89D1D0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'DATA ULANG',
                style: tahomaB.copyWith(
                  fontSize: getActualY(y: 30, context: context),
                  color: Colors.white,
                ),
              ),
              const BoxGap(
                height: 24,
              ),
              Text(
                'Update informasi\ndata kepesertaan Anda',
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
                    image: AssetImage('assets/images/slide3.png'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
        )
      ],
    );
  }
}
