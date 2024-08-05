import 'package:dapenda/app/constant.dart';
import 'package:dapenda/app/url.dart';
import 'package:dapenda/model/data_peserta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/berkas_cubit/berkas_ulang_cubit.dart';
import '../../model/berkas.dart';
import '../../themes/themes.dart';
import '../../widgets/base_appbar.dart';
import '../../widgets/box_gap.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/text-rapi.dart';

class UnggahFalse extends StatefulWidget {
  final DataPeserta dataPeserta;
  final Berkas berkas;

  const UnggahFalse(
      {super.key, required this.berkas, required this.dataPeserta});
  @override
  _UnggahFalseState createState() => _UnggahFalseState();
}

class _UnggahFalseState extends State<UnggahFalse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppbar(
        title: "Kembali",
        backgroundColor: blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 16, top: 40, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/failed.png'),
                      ),
                    ),
                  ),
                  const BoxGap(
                    width: 16,
                  ),
                  Text(
                    'Validasi Berkas Gagal',
                    style: tahomaB.copyWith(
                      fontSize: getActualY(y: 20, context: context),
                      color: Color(0XFFFC8276),
                    ),
                  ),
                ],
              ),
              const BoxGap(height: 32),
              Text(
                'Alasan Gagal : ',
                style: tahomaB.copyWith(
                  color: Color(0XFFFC8276),
                  fontSize: 18,
                ),
              ),
              const BoxGap(height: 8),
              Text(
                widget.berkas.alasan != null
                    ? widget.berkas.alasan!
                    : 'Belum diverifikasi, mohon untuk menunggu.',
                style: tahomaR.copyWith(
                  color: Color(0XFF757575),
                  fontSize: 14,
                ),
              ),
              const BoxGap(height: 32),
              TextRapi(
                data: 'Nama Penerima Pensiun',
                value: widget.dataPeserta.nmPenerimaMp,
              ),
              TextRapi(
                data: 'Nomor eDU',
                value: widget.dataPeserta.noEdu,
              ),
              TextRapi(
                data: 'Nomor Pensiunan / NIP',
                value: widget.dataPeserta.nip,
              ),
              TextRapi(
                data: 'Jenis Pensiun',
                value: widget.dataPeserta.jnsPensiun,
              ),
              const BoxGap(height: 32),
              Text(
                "Foto KTP",
                style: tahomaR.copyWith(
                  color: Color(0XFF757575),
                  fontSize: 14,
                ),
              ),
              const BoxGap(height: 16),
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(baseUrlImage + widget.berkas.file1!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const BoxGap(height: 16),
              Text(
                "Foto Kartu KK",
                style: tahomaR.copyWith(
                  color: Color(0XFF757575),
                  fontSize: 14,
                ),
              ),
              const BoxGap(height: 16),
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(baseUrlImage + widget.berkas.file2!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const BoxGap(height: 32),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  child: CustomButton(
                    onPressed: () {
                      context.read<BerkasUlangCubit>().setValue(true);
                    },
                    text: "ULANGI",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
