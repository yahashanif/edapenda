import 'package:dapenda/app/constant.dart';
import 'package:dapenda/app/routes.dart';
import 'package:dapenda/cubit/image_cubit/current_image_cubit.dart';
import 'package:dapenda/cubit/pendataan_foto_cubit/pendataan_foto_cubit.dart';
import 'package:dapenda/cubit/pendataan_foto_matrik_cubit/pendataan_foto_matrik_cubit.dart';
import 'package:dapenda/cubit/value_pendataan_foto_cubit/value_pendataan_foto_cubit.dart';
import 'package:dapenda/themes/themes.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:liveness_detection_flutter_plugin/index.dart';

class PendataanBaru extends StatefulWidget {
  @override
  State<PendataanBaru> createState() => _PendataanBaruState();
}

class _PendataanBaruState extends State<PendataanBaru> {
  File? dataFoto;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CurrentImageCubit>().setXFile(null);
  }

  @override
  Widget build(BuildContext context) {
    Box tokenBox = Hive.box('token');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BoxGap(
          height: defaultMargin,
        ),
        Center(
          child: Text(
            "Pendataan Foto Baru",
            textAlign: TextAlign.center,
            style: tahomaB.copyWith(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        const BoxGap(
          height: 8,
        ),
        Text(
          'Silakan Ambil Foto Selfie',
          style: tahomaB.copyWith(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const BoxGap(
          height: 32,
        ),
        GestureDetector(
          onTap: () async {
            // Navigator.pushNamed(context, recognationRoute);
            Navigator.pushNamed(context, pendataanCameraRoute);
          },
          /** 
           * 
           * Blok untuk data foto
           * cek ada tidak fotonya diambil
          */
          child: BlocBuilder<CurrentImageCubit, XFile?>(
            builder: (context, state) {
              if (state != null) {
                dataFoto = File(state.path);
                return Container(
                  width: double.infinity,
                  height: 380,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(state.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                return Container(
                  width: double.infinity,
                  height: 380,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      'Ketuk disini untuk ambil foto',
                      textAlign: TextAlign.center,
                      style: tahomaR.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        const BoxGap(
          height: 24,
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: getActualX(x: 8, context: context)),
          child: Row(
            children: [
              Expanded(
                  child: CustomButton(
                buttonColor: blue,
                borderColor: blue,
                text: "FOTO",
                onPressed: () {
                  Navigator.pushNamed(context, pendataanCameraRoute);
                },
              )),
              const BoxGap(
                width: 8,
              ),
              Expanded(
                  child: BlocConsumer<PendataanFotoCubit, PendataanFotoState>(
                listener: (context, state) {
                  if (state is PendataanFotoFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                      ),
                    );
                  }
                  if (state is PendataanFotoPosted) {
                    context
                        .read<PendataanFotoCubit>()
                        .pendataanFotoGet(token: tokenBox.get('token'));

                    context
                        .read<PendataanFotoMatrikCubit>()
                        .getPendataanFotoMatrik(token: tokenBox.get('token'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Data Berhasil Upload'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    isLoading: state is PendataanFotoLoading,
                    text: "SIMPAN",
                    onPressed: () {
                      List<double> dataMatriks =
                          context.read<ValuePendataanFotoCubit>().state ?? [];
                      if (dataMatriks.isEmpty || dataFoto == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Data tidak boleh kosong'),
                          ),
                        );
                      } else {
                        context.read<PendataanFotoCubit>().pendataanFotoPost(
                            token: tokenBox.get('token'),
                            matriks: dataMatriks,
                            file: dataFoto!);
                      }
                    },
                  );
                },
              ))
            ],
          ),
        )
      ],
    );
  }
}
