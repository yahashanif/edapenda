import 'package:dapenda/app/constant.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../model/data_auth.dart';
import '../../model/data_peserta.dart';
import '../../themes/themes.dart';
import '../../widgets/text-rapi.dart';

class UnggahAfter extends StatefulWidget {
  final DataPeserta data;
  final User user;

  const UnggahAfter({super.key, required this.data, required this.user});
  @override
  _UnggahAfterState createState() => _UnggahAfterState();
}

class _UnggahAfterState extends State<UnggahAfter> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size.height;
    // data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppbar(
        title: "Kembali",
        backgroundColor: blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 16, top: 40, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/success.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    'Unggah Berhasil',
                    style: tahomaB.copyWith(
                      fontSize: getActualY(y: 20, context: context),
                      color: Color(0XFF9AD25C),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaQuery * 0.02,
              ),
              Text(
                'Terima Kasih Bapak / Ibu\nTelah mengunggah Berkas Data Ulang',
                textAlign: TextAlign.center,
                style: tahomaB.copyWith(
                  fontSize: getActualY(y: 14, context: context),
                  color: const Color(0XFF9AD25C),
                ),
              ),
              SizedBox(
                height: mediaQuery * 0.08,
              ),
              TextRapi(
                data: 'Nomor e-DU',
                value: widget.data.noEdu,
              ),
              TextRapi(
                data: 'Nama Pensiunan',
                value: widget.user.nmPeserta,
              ),
              TextRapi(
                data: 'Penerima MP',
                value: widget.data.nmPenerimaMp,
              ),
              TextRapi(
                data: 'Nomor Pensiunan',
                value: widget.data.nip,
              ),
              TextRapi(
                data: 'Jenis Pensiun',
                value: widget.data.jnsPensiun,
              ),
              SizedBox(
                height: mediaQuery * 0.08,
              ),
              Text(
                'Verifikasi akan memakan waktu 1x24 jam\nSilakan Cek kembali besok',
                textAlign: TextAlign.center,
                style: tahomaB.copyWith(
                  fontSize: 14,
                  color: Color(0XFFFC8276),
                ),
              ),
              SizedBox(
                height: mediaQuery * 0.08,
              ),
              Container(
                  width: 100,
                  height: 40,
                  child: CustomButton(
                      text: "Tutup",
                      onPressed: () {
                        Navigator.pop(context);
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
