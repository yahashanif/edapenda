import 'package:dapenda/app/constant.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../themes/themes.dart';

// ignore: must_be_immutable
class Menu extends StatelessWidget {
  String? title;
  String? subtitle;
  String? image;
  Function? func;

  Menu({super.key, this.title, this.subtitle, this.image, this.func});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: getActualY(y: 8, context: context)),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0.4, 0.8),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title ?? '',
                  style: tahomaR.copyWith(
                    fontSize: getActualY(y: 24, context: context),
                  ),
                ),
                const BoxGap(
                  height: 8,
                ),
                Text(
                  subtitle ?? '',
                  style: tahomaR.copyWith(
                    fontSize: getActualY(y: 14, context: context),
                    color: const Color(0XFF757575),
                  ),
                ),
                const BoxGap(
                  height: 16,
                ),
                func == null
                    ? const SizedBox()
                    : SizedBox(
                        width: getActualX(x: 100, context: context),
                        height: getActualY(y: 40, context: context),
                        child: CustomButton(
                            text: "Masuk",
                            onPressed: () {
                              func!();
                            }))
              ],
            ),
          ),
          image == null
              ? const SizedBox()
              : Image.asset(
                  'assets/images/$image.png',
                  width: getActualX(x: 75, context: context),
                )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MenuOtentikasi extends StatelessWidget {
  String? title;
  String? subtitle;
  String? image;

  MenuOtentikasi({super.key, this.title, this.subtitle, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: getActualY(y: 8, context: context)),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            offset: const Offset(0.4, 0.8),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title ?? '',
                style: tahomaR.copyWith(
                  fontSize: getActualY(y: 24, context: context),
                ),
              ),
              const BoxGap(
                height: 8,
              ),
              Text(
                subtitle ?? '',
                style: tahomaR.copyWith(
                  fontSize: 14,
                  color: const Color(0XFF757575),
                ),
              ),
              const BoxGap(
                height: 16,
              ),
              SizedBox(
                width: getActualX(x: 150, context: context),
                child: Text(
                  'Silahkan Anda foto awal terlebih dahulu',
                  style: tahomaR.copyWith(
                    color: Colors.black,
                    fontSize: getActualY(y: 14, context: context),
                  ),
                ),
              )
            ],
          ),
          Image.asset('assets/images/$image.png')
        ],
      ),
    );
  }
}
