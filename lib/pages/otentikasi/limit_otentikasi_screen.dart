import 'package:dapenda/app/constant.dart';
import 'package:dapenda/cubit/data_peserta_cubit/data_peserta_cubit.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../themes/themes.dart';
import '../../widgets/text-rapi.dart';

class LimitOtenticationScreen extends StatelessWidget {
  final int limit;

  const LimitOtenticationScreen({super.key, required this.limit});

  @override
  Widget build(BuildContext context) {
    Box dataBox = Hive.box("countFoto");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppbar(
        title: "Otentikasi Gagal",
        centerTitle: false,
        backgroundColor: blue,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: getActualX(x: defaultMargin, context: context),
            vertical: getActualY(y: 48, context: context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/failed.png",
                  width: getActualX(x: 50, context: context),
                ),
                const BoxGap(
                  width: 12,
                ),
                Text(
                  "Otentikasi Gagal",
                  style: tahomaB.copyWith(
                      fontSize: getActualY(y: 20, context: context),
                      color: Colors.red.shade300),
                )
              ],
            ),
            BoxGap(
              height: 16,
            ),
            Text(
              "Otentikasi Gagal,\n Anda Punya Kesempatan",
              textAlign: TextAlign.center,
              style: tahomaB.copyWith(
                  fontSize: getActualY(y: 18, context: context),
                  color: Colors.red.shade300),
            ),
            const BoxGap(
              height: 12,
            ),
            Text(
              "$limit dari 3",
              textAlign: TextAlign.center,
              style: tahomaB.copyWith(
                  fontSize: getActualY(y: 20, context: context),
                  color: Colors.red.shade300),
            ),
            const BoxGap(
              height: 8,
            ),
            Text(
              "Mohon Ulangi Lagi",
              textAlign: TextAlign.center,
              style: tahomaB.copyWith(
                  fontSize: getActualY(y: 18, context: context),
                  color: Colors.red.shade300),
            ),
            BoxGap(
              height: 48,
            ),
            BlocBuilder<DataPesertaCubit, DataPesertaState>(
              builder: (context, state) {
                if (state is DataPesertaSuccess) {
                  return Column(
                    children: [
                      TextRapi(
                        data: 'Nomor e-DU',
                        value: state.data.noEdu,
                      ),
                      const BoxGap(
                        height: 8,
                      ),
                      TextRapi(
                        data: 'Nama Penerima Pensiun',
                        value: state.data.nmPenerimaMp,
                      ),
                      const BoxGap(
                        height: 8,
                      ),
                      TextRapi(
                        data: 'Nomor Pensiunan / NIP',
                        value: state.data.nip,
                      ),
                      const BoxGap(
                        height: 8,
                      ),
                      TextRapi(
                        data: 'Jenis Pensiun',
                        value: state.data.jnsPensiun,
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
            CustomButton(
                marginTop: getActualY(y: 48, context: context),
                width: MediaQuery.of(context).size.width / 3,
                text: "Tutup",
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
