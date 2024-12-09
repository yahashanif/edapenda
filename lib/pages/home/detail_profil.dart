import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/constant.dart';
import '../../model/data_auth.dart';
import '../../themes/themes.dart';
import '../../widgets/box_gap.dart';

class DetailProfil extends StatelessWidget {
  final User user;

  const DetailProfil({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;
    PickedFile? imageData;
    if (user.urlFoto != null) {
      bytes = base64Decode(user.urlFoto!);
    }
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
                user.ucapan ?? 'Selamat Pagi,',
                style: tahomaR.copyWith(
                  fontSize: getActualY(y: 24, context: context),
                ),
              ),
              const BoxGap(
                height: 8,
              ),
              Text(
                user.nmPeserta ?? '',
                style: tahomaB.copyWith(
                  fontSize: getActualY(y: 24, context: context),
                  color: const Color(0XFF757575),
                ),
              ),
              const BoxGap(
                height: 5,
              ),
              Text(
                user.noEdu ?? '',
                style: tahomaR.copyWith(
                  fontSize: getActualY(y: 14, context: context),
                  color: const Color(0XFF757575),
                ),
              ),
              const BoxGap(
                height: 5,
              ),
              Text(
              user.stsPen == "T" ? "MP Ditunda" :  "MP Dibayarkan",
                style: tahomaR.copyWith(
                  fontSize: getActualY(y: 14, context: context),
                  color: Color(0XFF757575),
                ),
              )
            ],
          ),
          bytes!.isEmpty
              ? Container()
              : Container(
                  height: 80,
                  width: 80,
                  child: Image.memory(
                    bytes!,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.5,
                  ),
                )
        ],
      ),
    );
  }
}
