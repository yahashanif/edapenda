import 'package:dapenda/app/constant.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:flutter/material.dart';

import '../../../themes/themes.dart';

class Slide1 extends StatelessWidget {
  const Slide1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const BoxGap(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: getActualY(y: 150, context: context),
                    bottom: getActualY(y: 8, context: context)),
                child: Text(
                  'Selamat Datang',
                  style: tahomaB.copyWith(
                    fontSize: getActualY(y: 30, context: context),
                    color: const Color(0XFF373737),
                  ),
                ),
              ),
              Text(
                'di Aplikasi e-DAPENDA',
                style: tahomaB.copyWith(
                  fontSize: getActualY(y: 30, context: context),
                  color: const Color(0XFF373737),
                ),
              ),
              const BoxGap(
                height: 60,
              ),
              Text(
                'Aplikasi Otentikasi\nData Ulang Pensiunan\nPT Angkasa Pura II (Persero)',
                textAlign: TextAlign.center,
                style: tahomaR.copyWith(
                  fontSize: getActualY(y: 24, context: context),
                  color: const Color(0XFF373737),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
