import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dapenda/app/constant.dart';
import 'package:dapenda/app/routes.dart';
import 'package:dapenda/cubit/auth_cubit/auth_cubit.dart';
import 'package:dapenda/cubit/data_peserta_cubit/data_peserta_cubit.dart';
import 'package:dapenda/model/province.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:intl/intl.dart';

import '../../cubit/berkas_cubit/berkas_cubit.dart';
import '../../cubit/berkas_cubit/berkas_ulang_cubit.dart';
import '../../cubit/province_cubit/province_cubit.dart';
import '../../themes/themes.dart';
import '../../widgets/DataUlangShimmer.dart';
import '../../widgets/box_gap.dart';
import '../../widgets/text-rapi.dart';

class DataUlangScreen extends StatefulWidget {
  const DataUlangScreen({super.key});

  @override
  State<DataUlangScreen> createState() => _DataUlangScreenState();
}

class _DataUlangScreenState extends State<DataUlangScreen> {
  Box tokenBox = Hive.box('token');
  String name = '';
  bool isLoading = false;
  bool isAgree = false;
  bool isErrorAgree = false;

  PickedFile? ktp;
  PickedFile? kk;
  PickedFile? npwp;
  PickedFile? menikah;
  PickedFile? kuliah;
  PickedFile? bekerja;
  bool _loading = false;

  Future<PickedFile?> getImage() async {
    // ignore: deprecated_member_use, invalid_use_of_visible_for_testing_member
    var image = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      imageQuality: 30, // <- Reduce Image quality
      maxHeight: 2048, // <- reduce the image size
      maxWidth: 2048,
    );
    setState(() {});

    return image;
  }

  // Future getImage2() async {
  //   // ignore: deprecated_member_use, invalid_use_of_visible_for_testing_member
  //   var image = await ImagePicker.platform.pickImage(
  //     source: ImageSource.camera,
  //     imageQuality: 100, // <- Reduce Image quality
  //     maxHeight: 2048, // <- reduce the image size
  //     maxWidth: 2048,
  //   );

  //   setState(() {
  //     gambar2 = image;
  //     ;
  //   });
  // }

  final _formKey = GlobalKey<FormState>();
  TextEditingController alamatTempatTinggalController = TextEditingController();
  TextEditingController kdPosController = TextEditingController();
  TextEditingController noHpController = TextEditingController();
  TextEditingController notlpController = TextEditingController();
  TextEditingController kegiatanController = TextEditingController();
  TextEditingController npwpController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController nameKerabatController = TextEditingController();
  TextEditingController noTelpKerabatController = TextEditingController();
  String? noedu;
  String? kdProp;
  Province? valueProp;
  bool init = true;
  int umur = 0;

  @override
  void initState() {
    super.initState();
    var dataState = context.read<DataPesertaCubit>().state;
    var authState = context.read<AuthCubit>().state;
    if (dataState is DataPesertaSuccess) {
      noedu = dataState.data.noEdu;
      alamatTempatTinggalController.text = dataState.data.alamat ?? '';
      kdPosController.text = dataState.data.kodePos ?? '';
      noHpController.text = dataState.data.noHp ?? '';
      notlpController.text = dataState.data.noTelp ?? '';
      kegiatanController.text = dataState.data.kegiatanPensiun ?? '';
      npwpController.text = dataState.data.npwp ?? '';
      kdProp = dataState.data.kdProp;
      nikController.text = dataState.data.nik ?? '';
      nameKerabatController.text = dataState.data.nameKerabat ?? '';
      noTelpKerabatController.text = dataState.data.telpKerabat ?? '';

      umur = DateTime.now().year -
          DateTime.parse(dataState.data.tglLahir ?? '').year;
    }

    var provinceState = context.read<ProvinceCubit>().state;
    if (provinceState is ProvinceLoaded) {
      valueProp = provinceState.province.firstWhere(
          (element) => element.kdProp == kdProp,
          orElse: () => provinceState.province.first);
    }
    if (authState is AuthSuccess) {
      name = authState.user.nmPeserta ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataUlangState = context.read<BerkasUlangCubit>().state;
    final berkasStateData = context.read<BerkasCubit>().state;

    // getBerkas() async {
    //   if (berkasStateData is BerkasLoaded) {
    //     print(berkasStateData.berkas.ktp == null);
    //     if (berkasStateData.berkas.ktp != null) {
    //       ktp = await convertBase64ToPickedFile(
    //           berkasStateData.berkas.ktp!, "ktp.png");
    //     }
    //     print("KTP");
    //     print(ktp);
    //     if (berkasStateData.berkas.kk != null) {
    //       kk = await convertBase64ToPickedFile(
    //           berkasStateData.berkas.kk!, "kk.png");
    //     }
    //     if (berkasStateData.berkas.suratKeteranganMasihKuliah != null) {
    //       kuliah = await convertBase64ToPickedFile(
    //           berkasStateData.berkas.suratKeteranganMasihKuliah!, "kuliah.png");
    //     }
    //     if (berkasStateData.berkas.suratKeteranganBelumBekerja != null) {
    //       bekerja = await convertBase64ToPickedFile(
    //           berkasStateData.berkas.suratKeteranganBelumBekerja!,
    //           "bekerja.png");
    //     }
    //   }
    // }

    // getBerkas();

    if (dataUlangState is DataPesertaUpdated) {
      context
          .read<DataPesertaCubit>()
          .getDataPeserta(token: tokenBox.get('token'));
    }
    validator(value) {
      if (value!.isEmpty) {
        return "*Wajib diisi";
      } else {
        return null;
      }
    }
/**
 * Pensiun Normal
 * Janda
 * Anak
 */

    // ignore: non_constant_identifier_names
    WidgetImage(
        {required String title,
        PickedFile? image,
        String? imageBase64,
        required Function() onTap}) {
      Uint8List? bytes;
      if (imageBase64 != null) {
        bytes = base64Decode(imageBase64.split(",").last);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tahomaR.copyWith(fontSize: 14),
          ),
          const BoxGap(
            height: 24,
          ),
          InkWell(
              onTap: () {
                onTap();
              },
              child: Align(
                  alignment: Alignment.center,
                  child:
                      // image != null || imageBase64 != null
                      //     ?
                      // imageBase64 == ''
                      // ? Container(
                      //     decoration: DottedDecoration(
                      //         shape: Shape.box,
                      //         color: blue,
                      //         borderRadius: BorderRadius.circular(8)),
                      //     // child: Image.memory(
                      //     //   bytes!,
                      //     //   width: MediaQuery.of(context).size.width,
                      //     //   height: MediaQuery.of(context).size.width * 0.5,
                      //     // ),
                      //   )
                      //     :
                      image == null && bytes == null
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      getActualX(x: 16, context: context),
                                  vertical:
                                      getActualY(y: 16, context: context)),
                              width: double.infinity,
                              decoration: DottedDecoration(
                                  shape: Shape.box,
                                  color: blue,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_enhance_rounded),
                                ],
                              )),
                            )
                          : image == null
                              ? imageBase64 == '' || imageBase64 == null
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: getActualX(
                                              x: 16, context: context),
                                          vertical: getActualY(
                                              y: 16, context: context)),
                                      width: double.infinity,
                                      decoration: DottedDecoration(
                                          shape: Shape.box,
                                          color: blue,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.camera_enhance_rounded),
                                        ],
                                      )),
                                    )
                                  : Container(
                                      decoration: DottedDecoration(
                                        shape: Shape.box,
                                        color: blue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          try {
                                            // Coba untuk menampilkan gambar dari bytes
                                            return Image.memory(
                                              bytes!,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                // Jika gambar tidak valid, tampilkan alternatif
                                                return Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                    size: 50,
                                                  ),
                                                );
                                              },
                                            );
                                          } catch (e) {
                                            // Tampilkan widget alternatif jika bytes tidak valid
                                            return Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons
                                                    .camera_enhance_rounded),
                                              ],
                                            ));
                                          }
                                        },
                                      ),
                                    )
                              : Container(
                                  decoration: DottedDecoration(
                                      shape: Shape.box,
                                      color: blue,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Image.file(
                                    File(image!.path),
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                ))),
          const BoxGap(
            height: 16,
          )
        ],
      );
    }

    BerkasBiasa() {
      return BlocBuilder<BerkasUlangCubit, bool>(
        builder: (context, berkasUlang) {
          return BlocConsumer<BerkasCubit, BerkasState>(
            listener: (context, state) async {
              // if (state is BerkasLoaded) {
              //   if (state.berkas.ktp != null) {
              //     ktp = await convertBase64ToPickedFile(
              //         state.berkas.ktp!, "ktp.png");
              //   }
              //   if (state.berkas.kk != null) {
              //     kk = await convertBase64ToPickedFile(
              //         state.berkas.kk!, "kk.png");
              //   }
              //   if (state.berkas.npwp != null) {
              //     npwp = await convertBase64ToPickedFile(
              //         state.berkas.npwp!, "npwp.png");
              //   }
              // }
            },
            builder: (context, state) {
              if (state is BerkasLoaded) {
                return Column(
                  children: [
                    WidgetImage(
                        title: "Berkas Foto KTP",
                        image: ktp,
                        //  berkasUlang == true || state.berkas.status == 1
                        //     ? ktp
                        //     : berkasUlang == false
                        //         ? null
                        //         : ktp,
                        imageBase64: state.berkas.ktp,
                        onTap: () async {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              ktp = await getImage();
                            });
                          }
                        }),
                    WidgetImage(
                        title: "Berkas Foto KK",
                        image: kk,
                        // berkasUlang == true || state.berkas.status == 1
                        //     ? kk
                        //     : berkasUlang == false
                        //         ? null
                        //         : kk,
                        imageBase64: state.berkas.kk,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              kk = await getImage();
                            });
                          }
                        }),
                    WidgetImage(
                        title:
                            "Berkas Foto NPWP Jika Ada, foto NPWP tidak Mandatori",
                        image: npwp,
                        imageBase64: state.berkas.npwp,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              npwp = await getImage();
                            });
                          }
                        }),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      );
    }

    BerkasJanda() {
      return BlocBuilder<BerkasUlangCubit, bool>(
        builder: (context, berkasUlang) {
          return BlocBuilder<BerkasCubit, BerkasState>(
            builder: (context, state) {
              if (state is BerkasLoaded) {
                return Column(
                  children: [
                    WidgetImage(
                        title: "Berkas Foto KTP",
                        image: ktp,
                        imageBase64: state.berkas.ktp,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              ktp = await getImage();
                            });
                          }
                        }),
                    WidgetImage(
                        title: "Berkas Foto KK",
                        image: kk,
                        imageBase64: state.berkas.kk,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              kk = await getImage();
                            });
                          }
                        }),
                    WidgetImage(
                        title:
                            "Berkas Foto NPWP Jika Ada, foto NPWP tidak Mandatori",
                        image: npwp,
                        imageBase64: state.berkas.npwp,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              npwp = await getImage();
                            });
                          }
                        }),
                    WidgetImage(
                        title: "Berkas Surat Keterangan Belum Menikah",
                        image: menikah,
                        imageBase64: state.berkas.suratKeteranganBelumMenikah,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              menikah = await getImage();
                            });
                          }
                        }),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      );
    }

    BerkasAnak({required int umr}) {
      return BlocBuilder<BerkasUlangCubit, bool>(
        builder: (context, berkasUlang) {
          return BlocConsumer<BerkasCubit, BerkasState>(
            listener: (context, state) async {},
            builder: (context, state) {
              if (state is BerkasLoaded) {
                return Column(
                  children: [
                    // WidgetImage(
                    //     title: "Berkas Surat Keterangan Belum Menikah",
                    //     image: berkasUlang ? null : menikah,
                    //     imageBase64: berkasUlang
                    //         ? null
                    //         : state.berkas.suratKeteranganBelumMenikah,
                    //     onTap: () {
                    //       setState(() async {
                    //         menikah = await getImage();
                    //       });
                    //     }),
                    umr >= 17
                        ? WidgetImage(
                            title: "Berkas Foto KTP",
                            image: ktp,
                            // berkasUlang == true || state.berkas.status == 1
                            //     ? ktp
                            //     : berkasUlang == false
                            //         ? ktp
                            //         : ktp,
                            imageBase64:
                                // berkasUlang ? null :
                                state.berkas.ktp,
                            onTap: () {
                              if (berkasUlang == false) {
                              } else {
                                setState(() async {
                                  ktp = await getImage();
                                });
                              }
                            })
                        : const BoxGap(),
                    WidgetImage(
                        title: "Berkas Foto KK",
                        image: kk,
                        // berkasUlang == true || state.berkas.status == 1
                        //     ? kk
                        //     : berkasUlang == false
                        //         ? kk
                        //         : kk,
                        imageBase64:
                            // berkasUlang ? null :
                            state.berkas.kk,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              kk = await getImage();
                            });
                          }
                        }),
                    WidgetImage(
                        title: "Berkas Surat Keterangan Masih Kuliah",
                        image: kuliah,
                        //  berkasUlang == true || state.berkas.status == 1
                        //     ? kuliah
                        //     : berkasUlang == false
                        //         ? null
                        //         : kuliah,
                        imageBase64:
                            // berkasUlang
                            //     ? null
                            //     :
                            state.berkas.suratKeteranganMasihKuliah,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              kuliah = await getImage();
                            });
                          }
                        }),
                    WidgetImage(
                        title: "Berkas Surat Keterangan Belum Bekerja",
                        image: bekerja,
                        //  berkasUlang == true || state.berkas.status == 1
                        //     ? bekerja
                        //     : berkasUlang == false
                        //         ? null
                        //         : bekerja,
                        imageBase64:
                            // berkasUlang
                            //     ? null
                            //     :
                            state.berkas.suratKeteranganBelumBekerja,
                        onTap: () {
                          if (berkasUlang == false) {
                          } else {
                            setState(() async {
                              bekerja = await getImage();
                            });
                          }
                        }),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BaseAppbar(
        title: "Data Ulang",
        centerTitle: false,
        backgroundColor: blue,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<BerkasCubit, BerkasState>(
          listener: (context, stateBerkas) async {
            print("berkasState 2 2");
            print(stateBerkas);

            if (stateBerkas is BerkasLoaded) {}
            if (stateBerkas is BerkasFailed) {
              context.read<BerkasUlangCubit>().setValue(true);

              isLoading = false;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(stateBerkas.error)));
            }
            // TODO: implement listener
            if (stateBerkas is BerkasPosted) {
              context.read<BerkasUlangCubit>().setValue(false);
              context
                  .read<BerkasCubit>()
                  .getBerkas(token: tokenBox.get('token'));
            }
          },
          builder: (context, berkasState) {
            if (berkasState is BerkasLoaded) {
              if (berkasState.berkas.status == 1) {
                context.read<BerkasUlangCubit>().setValue(true);
              }
            }
            print("berkasState");
            print(berkasState);
            if (berkasState is BerkasFailed) {
              print(berkasState.error);
              // ScaffoldMessenger.of(context)
              //     .showSnackBar(SnackBar(content: Text(berkasState.error)));
            }
            return Column(
              children: [
                BlocBuilder<BerkasUlangCubit, bool>(
                  builder: (context, berkasUlang) {
                    return berkasState is BerkasLoaded
                        // ? berkasUlang == false
                        ? berkasState.berkas.status == 4
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        getActualY(y: 12, context: context),
                                    horizontal: getActualX(
                                        x: defaultMargin, context: context)),
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        getActualX(x: 12, context: context),
                                    vertical:
                                        getActualY(y: 8, context: context)),
                                decoration: BoxDecoration(
                                    boxShadow: [defaultBoxShadow],
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.red.shade200),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.red.shade200,
                                    ),
                                    BoxGap(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Berkas Data Ulang tidak disetujui",
                                        style: tahomaR,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : berkasState.berkas.status == 2
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            getActualY(y: 12, context: context),
                                        horizontal: getActualX(
                                            x: defaultMargin,
                                            context: context)),
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getActualX(x: 12, context: context),
                                        vertical:
                                            getActualY(y: 8, context: context)),
                                    decoration: BoxDecoration(
                                        boxShadow: [defaultBoxShadow],
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.blue.shade200),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.info,
                                          color: Colors.blue.shade200,
                                        ),
                                        BoxGap(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Menunggu Verifikasi Berkas Data Ulang",
                                            style: tahomaR,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const BoxGap()
                        // : const BoxGap()
                        : const BoxGap();
                  },
                ),
                BoxGap(
                  height: 8,
                ),
                BlocConsumer<DataPesertaCubit, DataPesertaState>(
                  listener: (context, state) {
                    print("state");
                    print(state);
                    if (state is DataPesertaSuccess) {
                      print("kdProp");
                      print(kdProp);
                    }
                    if (state is DataPesertaUpdated) {
                      context
                          .read<DataPesertaCubit>()
                          .getDataPeserta(token: tokenBox.get('token'));
                    }
                    if (state is DataPesertaFailed) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                      context
                          .read<DataPesertaCubit>()
                          .getDataPeserta(token: tokenBox.get('token'));
                    }
                  },
                  builder: (context, state) {
                    print(state);
                    if (state is DataPesertaSuccess) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: getActualX(x: 16, context: context),
                            vertical: getActualY(y: 24, context: context)),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'DATA ULANG',
                                  style: tahomaB.copyWith(
                                    fontSize:
                                        getActualY(y: 26, context: context),
                                    color: green,
                                  ),
                                ),
                              ),
                              const BoxGap(
                                height: 32,
                              ),
                              const Text(
                                "Dana Pensiun Angkasa Pura II menjamin kerahasiaan data Peserta Penerima Manfaat Pensiun sesuai dengan peraturan perundangan yang berlaku.",
                                style: tahomaR,
                              ),
                              const BoxGap(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  BlocBuilder<BerkasUlangCubit, bool>(
                                      builder: (context, berkasUlangState) {
                                    return BlocBuilder<BerkasUlangCubit, bool>(
                                      builder: (context, state) {
                                        return Checkbox(
                                            value: berkasState is BerkasLoaded
                                                ? berkasState.berkas.status == 1
                                                    ? isAgree
                                                    : berkasUlangState
                                                        ? isAgree
                                                        : true
                                                : false,
                                            onChanged: (value) {
                                              setState(() {
                                                isAgree = value!;
                                              });
                                            });
                                      },
                                    );
                                  }),
                                  Expanded(
                                      child: Text(
                                    "Dengan ini saya sebagai Penerima Manfaat Pensiun menyetujui bahwa data pribadi saya dapat di pergunakan oleh Dana Pensiun Angkasa Pura II dan afiliasinya dalam melakukan pemrosesan/pengelolaan data sesuai dengan fungsi dan tujuan Dana Pensiun",
                                    style: tahomaR.copyWith(
                                        fontSize: getActualY(
                                            y: 12, context: context)),
                                  ))
                                ],
                              ),
                              const BoxGap(
                                height: 12,
                              ),
                              Text(
                                name,
                                style: tahomaB.copyWith(
                                  fontSize: getActualY(y: 16, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextRapi(
                                data: 'Nama Penerima Pensiun',
                                value: state.data.nmPenerimaMp,
                              ),
                              TextRapi(
                                data: 'Nopen',
                                value: state.data.noEdu!
                                    .substring(state.data.noEdu!.length - 4),
                              ),
                              TextRapi(
                                data: 'Status MP',
                                value: state.data.stsMp,
                              ),
                              TextRapi(
                                data: 'Tempat, Tanggal Lahir',
                                value:
                                    "${state.data.tempatLahir!}, ${state.data.tglLahir}",
                              ),
                              TextRapi(
                                data: 'Nomor Pensiunan',
                                value: state.data.nip,
                              ),
                              TextRapi(
                                data: 'Status Keluarga terakhir',
                                value: state.data.stsKelAkhir,
                              ),
                              TextRapi(
                                data: 'Alamat Tempat Tinggal',
                                value: '',
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                // initialValue: state.data.alamat,
                                validator: validator,
                                onChanged: (value) {
                                  alamatTempatTinggalController.text = value;
                                },
                                // onSaved: (val) => _alamat = val,
                                maxLines: 4,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Alamat Tempat Tinggal Sekarang',
                                  hintStyle: tahomaR.copyWith(fontSize: 14),
                                ),
                                controller: alamatTempatTinggalController,
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'Provinsi ',
                                style: tahomaR.copyWith(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      left:
                                          getActualX(x: 10, context: context)),
                                  decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color: Colors.grey,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: BlocConsumer<ProvinceCubit,
                                          ProvinceState>(
                                      listener: (context, provinsiState) {
                                    if (provinsiState is ProvinceLoaded) {
                                      if (kdProp != null) {
                                        valueProp = provinsiState.province
                                            .where((element) =>
                                                element.kdProp == kdProp)
                                            .first;
                                      }
                                    }
                                  }, builder: (context, state) {
                                    if (state is ProvinceFailed) {
                                      print(state.error);
                                    }
                                    print(state);
                                    if (state is ProvinceLoaded) {
                                      return DropdownButton<Province>(
                                        underline: Container(
                                          height: 0,
                                        ),
                                        isExpanded: true,
                                        hint: Text(
                                          "Provinsi",
                                          style: tahomaR.copyWith(fontSize: 14),
                                        ),
                                        value: valueProp,
                                        items: state.province.map(
                                          (item) {
                                            return DropdownMenuItem<Province>(
                                              child: Text(
                                                item.nmProp!,
                                                style: tahomaR.copyWith(
                                                    fontSize: 14),
                                              ),
                                              value: item,
                                            );
                                          },
                                        ).toList(),
                                        onChanged: (value) => {
                                          setState(
                                            () {
                                              valueProp = value;
                                            },
                                          )
                                        },
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  })),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'Kode POS ',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                validator: validator,

                                controller: kdPosController,
                                keyboardType: TextInputType.number,
                                // onSaved: (val) => _kodepos = val,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Kode POS',
                                  hintStyle: tahomaR.copyWith(
                                      fontSize:
                                          getActualY(y: 14, context: context)),
                                ),
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'Nomor HP ',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                validator: validator,

                                controller: noHpController,
                                keyboardType: TextInputType.number,
                                // onSaved: (val) => _nohp = val,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Nomor HP',
                                  hintStyle: tahomaR.copyWith(
                                      fontSize:
                                          getActualY(y: 14, context: context)),
                                ),
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'Nomor Telepon ',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                validator: validator,

                                controller: notlpController,
                                keyboardType: TextInputType.number,
                                // onSaved: (val) => _notelp = val,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Nomor Telepon',
                                  hintStyle: tahomaR.copyWith(
                                      fontSize:
                                          getActualY(y: 14, context: context)),
                                ),
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'NIK Sesuai KTP',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                validator: validator,

                                controller: nikController,
                                keyboardType: TextInputType.number,
                                // onSaved: (val) => _notelp = val,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'NIK',
                                  hintStyle: tahomaR.copyWith(
                                      fontSize:
                                          getActualY(y: 14, context: context)),
                                ),
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'NPWP Jika Ada',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                controller: npwpController,
                                keyboardType: TextInputType.number,
                                // onSaved: (val) => _notelp = val,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'NPWP',
                                  hintStyle: tahomaR.copyWith(
                                      fontSize:
                                          getActualY(y: 14, context: context)),
                                ),
                              ),
                              BoxGap(
                                  height: getActualY(y: 16, context: context)),
                              Text(
                                'Kontak Kerabat Tidak Serumah : ',
                                style: tahomaB.copyWith(
                                  fontSize: getActualY(y: 16, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              BoxGap(
                                height: getActualY(y: 16, context: context),
                              ),
                              Text(
                                'Nama Kerabat',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                validator: validator,

                                controller: nameKerabatController,
                                // keyboardType: TextInputType.number,
                                // onSaved: (val) => _notelp = val,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Nama Kerabat',
                                  hintStyle: tahomaR.copyWith(
                                      fontSize:
                                          getActualY(y: 14, context: context)),
                                ),
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'Nomor Telepon ',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                validator: validator,

                                controller: noTelpKerabatController,
                                keyboardType: TextInputType.number,
                                // onSaved: (val) => _notelp = val,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Nomor Telepon',
                                  hintStyle: tahomaR.copyWith(
                                      fontSize:
                                          getActualY(y: 14, context: context)),
                                ),
                              ),
                              const BoxGap(
                                height: 20,
                              ),
                              Text(
                                'Adalah Penerima Hak Manfaat Pensiun dari :',
                                style: tahomaB.copyWith(
                                  fontSize: getActualY(y: 16, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'Untuk pembayaran Manfaat Pensiun bulanan,\nMohon ditransfer ke:',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${state.data.nmBankPeserta} Cab ",
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${state.data.noRekPeserta} Atas Nama ${state.data.nmRekPeserta}",
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 32,
                              ),
                              Text(
                                'Demikian Pernyataan Ini Saya Buat\nDengan Sebenarnya, Sebagai Pemenuhan Kewajiban Kepada DAPENDA',
                                style: tahomaB.copyWith(
                                  fontSize: getActualY(y: 16, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'Kegiatan Pensiun ',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 8,
                              ),
                              TextFormField(
                                validator: validator,

                                controller: kegiatanController,
                                // initialValue: _kegiatan != null ? _kegiatan : '',
                                // onSaved: (val) => _kegiatan = val,
                                style: tahomaR.copyWith(
                                    fontSize:
                                        getActualY(y: 14, context: context)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: 'Kegiatan Pensiun',
                                  hintStyle: tahomaR.copyWith(fontSize: 14),
                                ),
                              ),
                              const BoxGap(
                                height: 24,
                              ),
                              state.data.stsKelAkhir == "Janda" ||
                                      state.data.stsKelAkhir == "Duda"
                                  ? BerkasJanda()
                                  : state.data.stsKelAkhir == "Anak"
                                      ? BerkasAnak(umr: umur)
                                      : BerkasBiasa(),
                              const BoxGap(
                                height: 12,
                              ),
                              isErrorAgree
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: getActualY(
                                              y: 4, context: context)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Colors.red,
                                            size: getActualY(
                                                y: 20, context: context),
                                          ),
                                          BoxGap(
                                            width: 4,
                                          ),
                                          Text(
                                            "Pernyataan persetujuan wajib di ceklis",
                                            style: tahomaR.copyWith(
                                                fontSize: 10,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              const BoxGap(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: BlocBuilder<BerkasUlangCubit, bool>(
                                  builder: (context, berkasUlangState) {
                                    // return Text(berkasState is BerkasLoaded ? berkasState.berkas.status.toString() : '');
                                    return berkasState is BerkasLoaded
                                        ? berkasUlangState == true ||
                                                berkasState.berkas.status == 1
                                            ? isLoading == false
                                                ? CustomButton(
                                                    isLoading: state
                                                            is DataPesertaLoading &&
                                                        berkasState
                                                            is BerkasLoading,
                                                    text: "Simpan",
                                                    onPressed: () async {
                                                      print("valueProp");
                                                      print(valueProp);
                                                      var fileKuliah = kuliah ==
                                                              null
                                                          ? berkasState.berkas
                                                                      .suratKeteranganMasihKuliah ==
                                                                  null
                                                              ? null
                                                              : File((await convertBase64ToPickedFile(
                                                                      berkasState
                                                                          .berkas
                                                                          .suratKeteranganMasihKuliah!,
                                                                      "kuliah.png"))
                                                                  .path)
                                                          : File(kuliah!.path);

                                                      var filekk = kk == null
                                                          ? berkasState.berkas
                                                                      .kk ==
                                                                  null
                                                              ? null
                                                              : File((await convertBase64ToPickedFile(
                                                                      berkasState
                                                                          .berkas
                                                                          .kk!,
                                                                      "kk.png"))
                                                                  .path)
                                                          : File(kk!.path);

                                                      print(filekk);

                                                      var filebekerja = bekerja ==
                                                              null
                                                          ? berkasState.berkas
                                                                      .suratKeteranganBelumBekerja ==
                                                                  null
                                                              ? null
                                                              : File((await convertBase64ToPickedFile(
                                                                      berkasState
                                                                          .berkas
                                                                          .suratKeteranganBelumBekerja!,
                                                                      "bekerja.png"))
                                                                  .path)
                                                          : File(bekerja!.path);

                                                      var fileKTP = ktp == null
                                                          ? berkasState.berkas
                                                                      .ktp ==
                                                                  null
                                                              ? null
                                                              : File((await convertBase64ToPickedFile(
                                                                      berkasState
                                                                          .berkas
                                                                          .ktp!,
                                                                      "ktp.png"))
                                                                  .path)
                                                          : File(ktp!.path);

                                                      var filemenikah = menikah ==
                                                              null
                                                          ? berkasState.berkas
                                                                      .suratKeteranganBelumMenikah ==
                                                                  null
                                                              ? null
                                                              : File((await convertBase64ToPickedFile(
                                                                      berkasState
                                                                          .berkas
                                                                          .suratKeteranganBelumMenikah!,
                                                                      "menikah.png"))
                                                                  .path)
                                                          : File(menikah!.path);

                                                      var fileNPWP = npwp ==
                                                              null
                                                          ? berkasState.berkas
                                                                      .npwp ==
                                                                  null
                                                              ? null
                                                              : File((await convertBase64ToPickedFile(
                                                                      berkasState
                                                                          .berkas
                                                                          .npwp!,
                                                                      "npwp.png"))
                                                                  .path)
                                                          : File(npwp!.path);

                                                      setState(() {
                                                        if (isAgree) {
                                                          isErrorAgree = false;
                                                        } else {
                                                          isErrorAgree = true;
                                                        }
                                                      });
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        setState(() {});
                                                        if (isAgree == false) {
                                                          setState(() {
                                                            isErrorAgree = true;
                                                          });

                                                          Future(() {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                content: Text(
                                                                  "Pernyataan persetujuan wajib di ceklis ",
                                                                  style: tahomaR
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.white),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                        } else if (valueProp ==
                                                            null) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      content:
                                                                          Text(
                                                                        "Kolom provinsi tidak boleh kosong",
                                                                        style: tahomaR.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      )));
                                                        } else {
                                                          if (state.data
                                                                      .stsKelAkhir ==
                                                                  "Janda" ||
                                                              state.data
                                                                      .stsKelAkhir ==
                                                                  "Duda") {
                                                            if (filekk ==
                                                                    null ||
                                                                fileKTP ==
                                                                    null ||
                                                                filemenikah ==
                                                                    null) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          content:
                                                                              Text(
                                                                            "Kolom Berkas KK, Berkas KTP dan Berkas Surat Keterangan Belum Menikah tidak boleh kosong",
                                                                            style:
                                                                                tahomaR.copyWith(color: Colors.white),
                                                                          )));
                                                            } else {
                                                              context.read<DataPesertaCubit>().updateDataPeserta(
                                                                  token: tokenBox.get(
                                                                      'token'),
                                                                  edu: state
                                                                      .data
                                                                      .noEdu!,
                                                                  kegiatan:
                                                                      kegiatanController
                                                                          .text,
                                                                  alamat:
                                                                      alamatTempatTinggalController
                                                                          .text,
                                                                  telp:
                                                                      notlpController
                                                                          .text,
                                                                  hp: noHpController
                                                                      .text,
                                                                  prop: valueProp!
                                                                      .kdProp!,
                                                                  nik: nikController
                                                                      .text,
                                                                  npwp: npwpController
                                                                          .text
                                                                          .isEmpty
                                                                      ? ''
                                                                      : npwpController
                                                                          .text,
                                                                  pos:
                                                                      kdPosController
                                                                          .text,
                                                                  nameKerabat:
                                                                      nameKerabatController
                                                                          .text,
                                                                  telpKerabat:
                                                                      noTelpKerabatController
                                                                          .text,
                                                                  aggrement:
                                                                      isAgree);

                                                              // var fileKK = File(
                                                              //     kk!.path);

                                                              if (npwp ==
                                                                  null) {
                                                                isLoading =
                                                                    true;
                                                                context
                                                                    .read<
                                                                        BerkasCubit>()
                                                                    .postBerkas(
                                                                        token: tokenBox
                                                                            .get('token'),
                                                                        keys: [
                                                                      'kk',
                                                                      'ktp',
                                                                      // 'npwp',
                                                                      'surat_keterangan_belum_menikah'
                                                                    ],
                                                                        files: [
                                                                      filekk!,
                                                                      fileKTP!,

                                                                      // fileNPWP,
                                                                      filemenikah!
                                                                    ]);
                                                              } else {
                                                                isLoading =
                                                                    true;

                                                                context
                                                                    .read<
                                                                        BerkasCubit>()
                                                                    .postBerkas(
                                                                        token: tokenBox
                                                                            .get('token'),
                                                                        keys: [
                                                                      'kk',
                                                                      'ktp',
                                                                      'npwp',
                                                                      'surat_keterangan_belum_menikah'
                                                                    ],
                                                                        files: [
                                                                      filekk!,
                                                                      fileKTP!,
                                                                      fileNPWP!,
                                                                      filemenikah!
                                                                    ]);
                                                              }
                                                            }
                                                          } else if (state.data
                                                                  .stsKelAkhir ==
                                                              "Anak") {
                                                            print(umur);
                                                            if (umur <= 17) {
                                                              if (filekk ==
                                                                      null ||
                                                                  fileKuliah ==
                                                                      null ||
                                                                  filebekerja ==
                                                                      null) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            content: Text(
                                                                              "Kolom Berkas Keterangan Masih Kuliah, Berkas Surat Keterangan Belum Bekerja dan Berkas Kartu Keluarga tidak boleh kosong",
                                                                              style: tahomaR.copyWith(color: Colors.white),
                                                                            )));
                                                              } else {
                                                                isLoading =
                                                                    true;

                                                                print(
                                                                    "DIBAWAH 17");

                                                                context.read<DataPesertaCubit>().updateDataPeserta(
                                                                    token: tokenBox.get(
                                                                        'token'),
                                                                    edu: state
                                                                        .data
                                                                        .noEdu!,
                                                                    kegiatan:
                                                                        kegiatanController
                                                                            .text,
                                                                    alamat:
                                                                        alamatTempatTinggalController
                                                                            .text,
                                                                    telp: notlpController
                                                                        .text,
                                                                    hp: noHpController
                                                                        .text,
                                                                    prop: valueProp!
                                                                        .kdProp!,
                                                                    nik: nikController
                                                                        .text,
                                                                    npwp: npwpController
                                                                        .text,
                                                                    pos: kdPosController
                                                                        .text,
                                                                    nameKerabat:
                                                                        nameKerabatController
                                                                            .text,
                                                                    telpKerabat:
                                                                        noTelpKerabatController
                                                                            .text,
                                                                    aggrement:
                                                                        isAgree);

                                                                // var filemenikah = menikah ==
                                                                //         null
                                                                //     ? File((await convertBase64ToPickedFile(
                                                                //             berkasState
                                                                //                 .berkas.suratKeteranganBelumMenikah!,
                                                                //             "menikah.png"))
                                                                //         .path)
                                                                //     : File(menikah!
                                                                //         .path);
                                                                // var filebekerka = bekerja ==
                                                                //         null
                                                                //     ? File((await convertBase64ToPickedFile(
                                                                //             berkasState
                                                                //                 .berkas.suratKeteranganBelumBekerja!,
                                                                //             "bekerja.png"))
                                                                //         .path)
                                                                //     : File(bekerja!
                                                                //         .path);
                                                                // var fileKuliah = kuliah ==
                                                                //         null
                                                                //     ? File((await convertBase64ToPickedFile(
                                                                //             berkasState
                                                                //                 .berkas.suratKeteranganMasihKuliah!,
                                                                //             "kuliah.png"))
                                                                //         .path)
                                                                //     : File(kuliah!
                                                                //         .path);

                                                                print(
                                                                    fileKuliah);

                                                                context
                                                                    .read<
                                                                        BerkasCubit>()
                                                                    .postBerkas(
                                                                        token: tokenBox
                                                                            .get('token'),
                                                                        keys: [
                                                                      'kk',
                                                                      'surat_keterangan_masih_kuliah',
                                                                      'surat_keterangan_belum_bekerja',
                                                                    ],
                                                                        files: [
                                                                      filekk!,
                                                                      fileKuliah!,
                                                                      filebekerja!,
                                                                    ]);
                                                              }
                                                            } else {
                                                              print(
                                                                  "UMUR => $umur");
                                                              print(kk);
                                                              if (fileKTP ==
                                                                      null ||
                                                                  filekk ==
                                                                      null ||
                                                                  fileKuliah ==
                                                                      null ||
                                                                  filebekerja ==
                                                                      null) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            content: Text(
                                                                              "Kolom Berkas Keterangan Masih Kuliah,Berkas KTP, Berkas Surat Keterangan Belum Bekerja dan Berkas Kartu Keluarga tidak boleh kosong",
                                                                              style: tahomaR.copyWith(color: Colors.white),
                                                                            )));
                                                              } else {
                                                                print(
                                                                    "UMUR ==> $umur");
                                                                isLoading =
                                                                    true;

                                                                context.read<DataPesertaCubit>().updateDataPeserta(
                                                                    token: tokenBox.get(
                                                                        'token'),
                                                                    edu: state
                                                                        .data
                                                                        .noEdu!,
                                                                    kegiatan:
                                                                        kegiatanController
                                                                            .text,
                                                                    alamat:
                                                                        alamatTempatTinggalController
                                                                            .text,
                                                                    telp: notlpController
                                                                        .text,
                                                                    hp: noHpController
                                                                        .text,
                                                                    prop: valueProp!
                                                                        .kdProp!,
                                                                    nik: nikController
                                                                        .text,
                                                                    npwp: npwpController
                                                                        .text,
                                                                    pos: kdPosController
                                                                        .text,
                                                                    nameKerabat:
                                                                        nameKerabatController
                                                                            .text,
                                                                    telpKerabat:
                                                                        noTelpKerabatController
                                                                            .text,
                                                                    aggrement:
                                                                        isAgree);

                                                                print(
                                                                    "DISINI MASUK");

                                                                // var fileKTP = ktp ==
                                                                //         null
                                                                //     ? File((await convertBase64ToPickedFile(
                                                                //             berkasState
                                                                //                 .berkas.ktp!,
                                                                //             "ktp.png"))
                                                                //         .path)
                                                                //     : File(ktp!
                                                                //         .path);
                                                                // var filekk = kk ==
                                                                //         null
                                                                //     ? File((await convertBase64ToPickedFile(
                                                                //             berkasState
                                                                //                 .berkas.kk!,
                                                                //             "kk.png"))
                                                                //         .path)
                                                                //     : File(kk!
                                                                //         .path);

                                                                // // var filemenikah =
                                                                // //     File(menikah!
                                                                // //         .path);
                                                                // var filebekerka = bekerja ==
                                                                //         null
                                                                //     ? File((await convertBase64ToPickedFile(
                                                                //             berkasState
                                                                //                 .berkas.suratKeteranganBelumBekerja!,
                                                                //             "bekerja.png"))
                                                                //         .path)
                                                                //     : File(bekerja!
                                                                //         .path);
                                                                // var fileKuliah = kuliah ==
                                                                //         null
                                                                //     ? berkasState.berkas.suratKeteranganMasihKuliah ==
                                                                //             null
                                                                //         ? null
                                                                //         : File((await convertBase64ToPickedFile(berkasState.berkas.suratKeteranganMasihKuliah!, "kuliah.png"))
                                                                //             .path)
                                                                //     : File(kuliah!
                                                                //         .path);

                                                                print(
                                                                    fileKuliah);
                                                                print(
                                                                    "PRINT MASUK SINI");
                                                                context
                                                                    .read<
                                                                        BerkasCubit>()
                                                                    .postBerkas(
                                                                        token: tokenBox
                                                                            .get('token'),
                                                                        keys: [
                                                                      'ktp',
                                                                      'kk',
                                                                      'surat_keterangan_masih_kuliah',
                                                                      'surat_keterangan_belum_bekerja',
                                                                    ],
                                                                        files: [
                                                                      fileKTP!,
                                                                      filekk!,
                                                                      fileKuliah!,
                                                                      filebekerja!,
                                                                    ]);
                                                              }
                                                            }
                                                          } else {
                                                            if (filekk ==
                                                                    null ||
                                                                fileKTP ==
                                                                    null) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          content:
                                                                              Text(
                                                                            "Kolom Berkas KK dan Berkas KTP  tidak boleh kosong",
                                                                            style:
                                                                                tahomaR.copyWith(color: Colors.white),
                                                                          )));
                                                            } else {
                                                              isLoading = true;

                                                              context.read<DataPesertaCubit>().updateDataPeserta(
                                                                  token: tokenBox.get(
                                                                      'token'),
                                                                  edu: state
                                                                      .data
                                                                      .noEdu!,
                                                                  kegiatan:
                                                                      kegiatanController
                                                                          .text,
                                                                  alamat:
                                                                      alamatTempatTinggalController
                                                                          .text,
                                                                  telp:
                                                                      notlpController
                                                                          .text,
                                                                  hp: noHpController
                                                                      .text,
                                                                  prop: valueProp!
                                                                      .kdProp!,
                                                                  nik: nikController
                                                                      .text,
                                                                  npwp:
                                                                      npwpController
                                                                          .text,
                                                                  pos: kdPosController
                                                                      .text,
                                                                  nameKerabat:
                                                                      nameKerabatController
                                                                          .text,
                                                                  telpKerabat:
                                                                      noTelpKerabatController
                                                                          .text,
                                                                  aggrement:
                                                                      isAgree);
                                                            }
                                                            // var fileKTP =
                                                            //     File(ktp!.path);
                                                            // var fileKK =
                                                            //     File(kk!.path);

                                                            if (fileNPWP ==
                                                                null) {
                                                              isLoading = true;

                                                              context
                                                                  .read<
                                                                      BerkasCubit>()
                                                                  .postBerkas(
                                                                      token: tokenBox
                                                                          .get(
                                                                              'token'),
                                                                      keys: [
                                                                    'kk',
                                                                    'ktp',
                                                                    // 'npwp'
                                                                  ],
                                                                      files: [
                                                                    filekk!,
                                                                    fileKTP!,

                                                                    // fileNPWP
                                                                  ]);
                                                            } else {
                                                              isLoading = true;

                                                              // var fileNPWP =
                                                              //     File(npwp!
                                                              //         .path);
                                                              context
                                                                  .read<
                                                                      BerkasCubit>()
                                                                  .postBerkas(
                                                                      token: tokenBox
                                                                          .get('token'),
                                                                      keys: [
                                                                    'kk',
                                                                    'ktp',
                                                                    'npwp'
                                                                  ],
                                                                      files: [
                                                                    filekk!,
                                                                    fileKTP!,
                                                                    fileNPWP!
                                                                  ]);
                                                            }
                                                          }
                                                        }
                                                      } else {
                                                        Future(() {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              content: Text(
                                                                "Semua kolom wajib diisi ",
                                                                style: tahomaR.copyWith(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                      }
                                                    })
                                                : berkasState.berkas.status == 2
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8),
                                                        height: 40,
                                                        child: CustomButton(
                                                          buttonColor:
                                                              Colors.blue,
                                                          borderColor:
                                                              Colors.blue,
                                                          onPressed: () {
                                                            // Navigator.pushReplacementNamed(context, '/unggah');
                                                            context
                                                                .read<
                                                                    BerkasUlangCubit>()
                                                                .setValue(true);
                                                            Navigator
                                                                .pushReplacementNamed(
                                                                    context,
                                                                    dataUlangRoute);
                                                          },
                                                          fontTextSize: 14,
                                                          text: "UPDATE BERKAS",
                                                          // text: berkasState.berkas.status.toString(),
                                                        ),
                                                      )
                                                    : berkasState.berkas
                                                                .status ==
                                                            4
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            height: 40,
                                                            child: CustomButton(
                                                              buttonColor:
                                                                  Colors.blue,
                                                              borderColor:
                                                                  Colors.blue,
                                                              onPressed: () {
                                                                // Navigator.pushReplacementNamed(context, '/unggah');
                                                                context
                                                                    .read<
                                                                        BerkasUlangCubit>()
                                                                    .setValue(
                                                                        true);
                                                                Navigator
                                                                    .pushReplacementNamed(
                                                                        context,
                                                                        dataUlangRoute);
                                                              },
                                                              fontTextSize: 14,
                                                              text:
                                                                  "UPDATE BERKAS",
                                                              // text: berkasState.berkas.status.toString(),
                                                            ),
                                                          )
                                                        : berkasState.berkas
                                                                    .status ==
                                                                3
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      height:
                                                                          40,
                                                                      child:
                                                                          CustomButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        text:
                                                                            "OKE",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8),
                                                                      height:
                                                                          40,
                                                                      child:
                                                                          CustomButton(
                                                                        onPressed:
                                                                            () {
                                                                          // Navigator.pushReplacementNamed(context, '/unggah');
                                                                          context
                                                                              .read<BerkasUlangCubit>()
                                                                              .setValue(true);
                                                                          Navigator.pushReplacementNamed(
                                                                              context,
                                                                              dataUlangRoute);
                                                                        },
                                                                        fontTextSize:
                                                                            14,
                                                                        text:
                                                                            "UPDATE BERKAS",
                                                                        buttonColor:
                                                                            Colors.blue,
                                                                        borderColor:
                                                                            Colors.blue,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container()
                                            : berkasState.berkas.status == 4
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    height: 40,
                                                    child: CustomButton(
                                                      onPressed: () {
                                                        // Navigator.pushReplacementNamed(context, '/unggah');
                                                        context
                                                            .read<
                                                                BerkasUlangCubit>()
                                                            .setValue(true);
                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                dataUlangRoute);
                                                      },
                                                      fontTextSize: 14,
                                                      text: "UPDATE BERKAS",
                                                      buttonColor: Colors.blue,
                                                      borderColor: Colors.blue,
                                                      // text: berkasState.berkas.status.toString(),
                                                    ),
                                                  )
                                                : Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    height: 40,
                                                    child: CustomButton(
                                                      onPressed: () {
                                                        // Navigator.pushReplacementNamed(context, '/unggah');
                                                        context
                                                            .read<
                                                                BerkasUlangCubit>()
                                                            .setValue(true);
                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                dataUlangRoute);
                                                      },
                                                      fontTextSize: 14,
                                                      text: "UPDATE BERKAS",
                                                      buttonColor: Colors.blue,
                                                      borderColor: Colors.blue,
                                                      // text: berkasState.berkas.status.toString(),
                                                    ),
                                                  )
                                        : Container();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return DataUlangShimmer();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
