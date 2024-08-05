import 'package:dapenda/app/constant.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../themes/themes.dart';

// ignore: must_be_immutable
class MenuVerified extends StatelessWidget {
  String? title;
  String? subtitle;
  String? image;

  MenuVerified({super.key, this.title, this.subtitle, this.image});

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
              Row(
                children: [
                  Container(
                    width: getActualX(x: 50, context: context),
                    height: getActualY(y: 50, context: context),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          image ?? '',
                        ),
                      ),
                    ),
                  ),
                  const BoxGap(width: 4),
                  SizedBox(
                    width: getActualX(x: 150, context: context),
                    child: Text(
                      subtitle ?? '',
                      style: tahomaR.copyWith(
                        fontSize: getActualY(y: 14, context: context),
                        color: const Color(0XFF757575),
                      ),
                    ),
                  ),
                ],
              ),
              const BoxGap(
                height: 8,
              ),
              SizedBox(
                  width: getActualX(x: 100, context: context),
                  height: getActualY(y: 40, context: context),
                  child: CustomButton(text: "Masuk", onPressed: () {})),
              const BoxGap(
                height: 16,
              ),
            ],
          ),
          Image.asset('assets/assets/pendataan.png')
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MenuVerifiedTwo extends StatelessWidget {
  String? title;
  String? subtitle;
  String? image;

  MenuVerifiedTwo({super.key, this.title, this.subtitle, this.image});

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
              Row(
                children: [
                  Container(
                    width: getActualX(x: 50, context: context),
                    height: getActualY(y: 50, context: context),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          image ?? '',
                        ),
                      ),
                    ),
                  ),
                  const BoxGap(width: 4),
                  SizedBox(
                    width: getActualX(x: 150, context: context),
                    child: Text(
                      subtitle ?? '',
                      style: tahomaR.copyWith(
                        fontSize: getActualY(y: 14, context: context),
                        color: const Color(0XFF757575),
                      ),
                    ),
                  ),
                ],
              ),
              const BoxGap(
                height: 16,
              ),
            ],
          ),
          Image.asset('assets/images/otentikasi.png')
        ],
      ),
    );
  }
}
