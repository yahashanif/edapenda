import 'package:dapenda/app/constant.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../themes/themes.dart';

class PetunjukBlok extends StatelessWidget {
  final Function() onTap;

  const PetunjukBlok({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar(
          title: "Petunjuk Unggah Berkas",
          backgroundColor: blue,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                left: getActualX(x: 10, context: context),
                top: getActualY(y: 16, context: context),
                right: getActualX(x: 10, context: context),
                bottom: getActualY(y: 16, context: context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'PETUNJUK UNGGAH\nBERKAS DATA ULANG',
                  textAlign: TextAlign.center,
                  style: tahomaB.copyWith(
                    color: Color(0XFF9AD25C),
                    fontSize: getActualY(y: 26, context: context),
                  ),
                ),
                const BoxGap(height: 16),
                Container(
                  width: double.infinity,
                  height: getActualY(y: 200, context: context),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
<<<<<<< HEAD
                            "https://edapenda.mhmfajar.my.id/assets/images/petunjuk_1.png"),
=======
                            "https://m.dapenda.co.id/assets/images/petunjuk_1.png"),
>>>>>>> 9f51bdf (commit lagi)
                        fit: BoxFit.cover),
                  ),
                ),
                const BoxGap(height: 16),
                Container(
                  width: double.infinity,
                  height: getActualY(y: 200, context: context),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
<<<<<<< HEAD
                            "https://edapenda.mhmfajar.my.id/assets/images/petunjuk_2.png"),
=======
                            "https://m.dapenda.co.id/assets/images/petunjuk_2.png"),
>>>>>>> 9f51bdf (commit lagi)
                        fit: BoxFit.cover),
                  ),
                ),
                const BoxGap(height: 24),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Pastikan Anda foto berkas seperti contoh diatas.',
                    style: tahomaR.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                const BoxGap(height: 24),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getActualX(x: 16, context: context)),
                      height: getActualY(y: 40, context: context),
                      child: CustomButton(text: "LANJUT", onPressed: onTap)),
                )
              ],
            ),
          ),
        ));
  }
}
