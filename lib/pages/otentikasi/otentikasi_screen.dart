import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dapenda/cubit/cek_otentikasi_cubit/cek_otentikasi_cubit.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/constant.dart';
import '../../app/routes.dart';
import '../../cubit/image_cubit/current_image_cubit.dart';
import '../../cubit/pendataan_foto_cubit/pendataan_foto_cubit.dart';
import '../../cubit/value_pendataan_foto_cubit/value_pendataan_foto_cubit.dart';
import '../../repository/ml_service.dart';
import '../../themes/themes.dart';
import '../../widgets/box_gap.dart';
import '../../widgets/circular_random_color.dart';
import '../../widgets/custom_button.dart';

class OtentikasiScreen extends StatefulWidget {
  const OtentikasiScreen({super.key});

  @override
  State<OtentikasiScreen> createState() => _OtentikasiScreenState();
}

class _OtentikasiScreenState extends State<OtentikasiScreen> {
  int _countdown = 5;
  Timer? _timer;
  late CameraController cameraController;
  File? dataFoto;
  bool result = false;
  bool init = true;
  Box dataBox = Hive.box("countFoto");
  int _countfoto = 0;
  String inputData = "";

  @override
  void initState() {
    super.initState();
    _countfoto = dataBox.get('countFoto') != null
        ? int.parse(dataBox.get('countFoto').toString())
        : 0;
    print(_countfoto);
    cameraController = CameraController(
      CameraDescription(
        name: "default",
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 90,
      ),
      ResolutionPreset.high,
    );

    context.read<CurrentImageCubit>().setXFile(null);
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          // Aksi setelah countdown selesai
        }
      });
    });
  }

  void _resetAll() {
    // Reset semua variabel terkait
    setState(() {
      _countdown = 5;
      dataFoto = null;
      result = false;
      init = true;
    });

    // Reset cubit yang terkait
    context.read<CurrentImageCubit>().setXFile(null);
    context.read<ValuePendataanFotoCubit>().setValue(null);

    // Hentikan countdown jika sedang berjalan
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkCameraStatus();

    Box tokenBox = Hive.box('token');
    return Scaffold(
      appBar: BaseAppbar(
        title: "Kembali",
        backgroundColor: blue,
        centerTitle: false,
      ),
      body: BlocConsumer<CekOtentikasiCubit, CekOtentikasiState>(
        listener: (context, state) {
          if (state is CekOtentikasiPosted) {
            Future(() {
              context
                  .read<CekOtentikasiCubit>()
                  .cekOtentikasi(token: tokenBox.get('token'));
            });
          } else if (state is CekOtentikasiFailed) {
            Future(() {
              context
                  .read<CekOtentikasiCubit>()
                  .cekOtentikasi(token: tokenBox.get('token'));
            });
          } else if (state is CekOtentikasiLoaded) {
            if (state.otentikasi.otentikasi == false) {
              Navigator.pushReplacementNamed(context, limitOtentikasiRoute,
                  arguments: state.otentikasi.count);
            } else {
              Navigator.pop(context);
            }
          }
        },
        builder: (context, cekOtentikasiState) {
          print(cekOtentikasiState);
          if (cekOtentikasiState is CekOtentikasiLoading) {
            return Center(
              child: ColorChangingProgressIndicator(),
            );
          }
          if (cekOtentikasiState is CekOtentikasiLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BoxGap(
                  height: defaultMargin,
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
                  onTap: cekOtentikasiState.otentikasi.count! >= 3
                      ? null
                      : () {
                          _resetAll();

                          // Memisahkan string berdasarkan koma dan mengonversi menjadi List<double>
                          List<double> numbers = inputData
                              .split(",")
                              .map((e) => double.parse(e))
                              .toList();
                          print(numbers);
                          Navigator.pushNamed(context, recognationRoute,
                              arguments: numbers);
                        },
                  child: BlocBuilder<PendataanFotoCubit, PendataanFotoState>(
                    builder: (context, fotoState) {
                      print(fotoState);
                      if (fotoState is PendataanFotoLoaded) {
                        return BlocBuilder<CurrentImageCubit, XFile?>(
                          builder: (context, state) {
                            List<double> valueFotoMatriks = [];
                            if (fotoState.pendataanFoto.matriks != null) {
                              inputData = fotoState.pendataanFoto.matriks!;

                              // Menghapus karakter [ dan ] dari string
                              inputData = inputData
                                  .replaceAll("[", "")
                                  .replaceAll("]", "");

                              // Memisahkan string berdasarkan koma dan mengonversi menjadi List<double>
                              List<double> numbers = inputData
                                  .split(",")
                                  .map((e) => double.parse(e))
                                  .toList();

                              valueFotoMatriks = numbers;
                            }
                            if (state != null) {
                              dataFoto = File(state.path);
                              if (init) {
                                _startCountdown();

                                MLService()
                                    .searchResult(valueFotoMatriks)
                                    .then((value) {
                                  setState(() {
                                    print(value);
                                    result = value;
                                    print(dataBox.get('countFoto'));
                                    int count = dataBox.get('countFoto') != null
                                        ? int.parse(
                                            dataBox.get('countFoto').toString())
                                        : 0;
                                    dataBox.put('countFoto', count + 1);
                                    _countfoto = int.parse(
                                        dataBox.get('countFoto').toString());
                                    print(dataBox.get('countFoto'));

                                    Future.delayed(Duration(seconds: 5), () {
                                      context
                                          .read<CekOtentikasiCubit>()
                                          .postOtentikasi(
                                              token: tokenBox.get('token'),
                                              verified: value,
                                              file: dataFoto!);
                                    });

                                    init = false;
                                  });
                                });
                              }
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
                        );
                      }
                      return Shimmer(
                        direction: ShimmerDirection.ltr,
                        gradient: LinearGradient(
                          stops: [0.2, 0.5, 0.8],
                          colors: [
                            Colors.grey[300]!,
                            Colors.grey[300]!.withOpacity(0.4),
                            Colors.grey[300]!
                          ],
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 135,
                          color: Colors.grey[300]!,
                        ),
                      );
                    },
                  ),
                ),
                const BoxGap(
                  height: 24,
                ),
                _countdown > 0 && dataFoto != null
                    ? const BoxGap()
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getActualX(x: 8, context: context)),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                buttonColor: blue,
                                borderColor: blue,
                                text: "FOTO",
                                onPressed:
                                    cekOtentikasiState.otentikasi.count! >= 3
                                        ? null
                                        : () {
                                            _resetAll();
                                            Navigator.pushNamed(
                                                context, recognationRoute);
                                          },
                              ),
                            ),
                            // const BoxGap(
                            //   width: 8,
                            // ),
                            // Expanded(
                            //   child: BlocConsumer<PendataanFotoCubit,
                            //       PendataanFotoState>(
                            //     listener: (context, state) {
                            //       if (state is PendataanFotoFailed) {
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //           SnackBar(
                            //             content: Text(state.error),
                            //           ),
                            //         );
                            //       }
                            //     },
                            //     builder: (context, state) {
                            //       return CustomButton(
                            //         isLoading: state is PendataanFotoLoading,
                            //         text: "SIMPAN",
                            //         onPressed: () {
                            //           List<double> dataMatriks = context
                            //                   .read<ValuePendataanFotoCubit>()
                            //                   .state ??
                            //               [];
                            //           if (dataMatriks.isEmpty || dataFoto == null) {
                            //             ScaffoldMessenger.of(context).showSnackBar(
                            //               SnackBar(
                            //                 content: Text('Data tidak boleh kosong'),
                            //               ),
                            //             );
                            //           } else {
                            //             // context.read<PendataanFotoCubit>().pendataanFotoPost(
                            //             //     token: tokenBox.get('token'),
                            //             //     matriks: dataMatriks,
                            //             //     File: dataFoto!);
                            //           }
                            //         },
                            //       );
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                      ),
                const BoxGap(
                  height: 16,
                ),
                _countdown <= 0 && dataFoto != null
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: getActualX(x: 8, context: context)),
                        decoration: BoxDecoration(
                            color: result ? green : Colors.red,
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(
                            horizontal: getActualX(x: 6, context: context),
                            vertical: getActualY(y: 6, context: context)),
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            result
                                ? "Wajah Anda Sesuai"
                                : "Wajah Anda Tidak Sesuai Silahkan Ulang lagi",
                            textAlign: TextAlign.center,
                            style: tahomaB.copyWith(
                                color: Colors.white,
                                fontSize: getActualY(y: 12, context: context)),
                          ),
                        ),
                      )
                    : const BoxGap(),
                _countdown > 0 && dataFoto != null
                    ? Center(
                        child: ColorChangingProgressIndicator(),
                      )
                    : Container(),
              ],
            );
          }
          return Shimmer(
            direction: ShimmerDirection.ltr,
            gradient: LinearGradient(
              stops: [0.2, 0.5, 0.8],
              colors: [
                Colors.grey[300]!,
                Colors.grey[300]!.withOpacity(0.4),
                Colors.grey[300]!
              ],
            ),
            child: Container(
              width: double.infinity,
              height: 135,
              color: Colors.grey[300]!,
            ),
          );
        },
      ),
    );
  }

  void checkCameraStatus() {
    if (cameraController.value.isInitialized) {
      print("Kamera sedang aktif.");
      if (cameraController.value.isStreamingImages) {
        print("Kamera sedang streaming gambar.");
      }
      if (cameraController.value.isRecordingVideo) {
        print("Kamera sedang merekam video.");
      }
    } else {
      print("Kamera tidak aktif.");
    }
  }
}
