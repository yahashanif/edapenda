import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dapenda/app/constant.dart';
import 'package:dapenda/cubit/data_peserta_cubit/data_peserta_cubit.dart';
import 'package:dapenda/model/province.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_decoration/dotted_decoration.dart';

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
      imageQuality: 100, // <- Reduce Image quality
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

  @override
  void initState() {
    super.initState();
    var dataState = context.read<DataPesertaCubit>().state;
    if (dataState is DataPesertaSuccess) {
      noedu = dataState.data.noEdu;
      alamatTempatTinggalController.text = dataState.data.alamat!;
      kdPosController.text = dataState.data.kodePos!;
      noHpController.text = dataState.data.noHp!;
      notlpController.text = dataState.data.noTelp!;
      kegiatanController.text = dataState.data.kegiatanPensiun!;
      npwpController.text = dataState.data.npwp!;
      kdProp = dataState.data.kdProp;
      nikController.text = dataState.data.nik!;
    }

    var provinceState = context.read<ProvinceCubit>().state;
    if (provinceState is ProvinceLoaded) {
      valueProp = provinceState.province.firstWhere(
          (element) => element.kdProp == kdProp,
          orElse: () => provinceState.province.first);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        bytes = base64Decode(imageBase64);
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
                child: image != null || imageBase64 != null
                    ? imageBase64 != null
                        ? Container(
                            decoration: DottedDecoration(
                                shape: Shape.box,
                                color: blue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Image.memory(
                              bytes!,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.5,
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
                              height: MediaQuery.of(context).size.width * 0.5,
                            ),
                          )
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getActualX(x: 16, context: context),
                            vertical: getActualY(y: 16, context: context)),
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
                      )),
          ),
          const BoxGap(
            height: 16,
          )
        ],
      );
    }

    BerkasBiasa() {
      return BlocBuilder<BerkasUlangCubit, bool>(
        builder: (context, berkasUlang) {
          return BlocBuilder<BerkasCubit, BerkasState>(
            builder: (context, state) {
              if (state is BerkasLoaded) {
                return Column(
                  children: [
                    WidgetImage(
                        title: "Berkas Foto KTP",
                        image: berkasUlang ? null : ktp,
                        imageBase64: berkasUlang ? null : state.berkas.ktp,
                        onTap: () async {
                          setState(() async {
                            ktp = await getImage();
                          });
                        }),
                    WidgetImage(
                        title: "Berkas Foto KK",
                        image: berkasUlang ? null : kk,
                        imageBase64: berkasUlang ? null : state.berkas.kk,
                        onTap: () {
                          setState(() async {
                            kk = await getImage();
                          });
                        }),
                    WidgetImage(
                        title: "Berkas Foto NPWP",
                        image: berkasUlang ? null : npwp,
                        imageBase64: berkasUlang ? null : state.berkas.npwp,
                        onTap: () {
                          setState(() async {
                            npwp = await getImage();
                          });
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
                        image: berkasUlang ? null : ktp,
                        imageBase64: berkasUlang ? null : state.berkas.ktp,
                        onTap: () {
                          setState(() async {
                            ktp = await getImage();
                          });
                        }),
                    WidgetImage(
                        title: "Berkas Foto KK",
                        image: berkasUlang ? null : kk,
                        imageBase64: berkasUlang ? null : state.berkas.kk,
                        onTap: () {
                          setState(() async {
                            kk = await getImage();
                          });
                        }),
                    WidgetImage(
                        title: "Berkas Foto NPWP",
                        image: berkasUlang ? null : npwp,
                        imageBase64: berkasUlang ? null : state.berkas.npwp,
                        onTap: () {
                          setState(() async {
                            npwp = await getImage();
                          });
                        }),
                    WidgetImage(
                        title: "Berkas Surat Keterangan Belum Menikah",
                        image: berkasUlang ? null : menikah,
                        imageBase64: berkasUlang
                            ? null
                            : state.berkas.suratKeteranganBelumMenikah,
                        onTap: () {
                          setState(() async {
                            menikah = await getImage();
                          });
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

    BerkasAnak() {
      return BlocBuilder<BerkasUlangCubit, bool>(
        builder: (context, berkasUlang) {
          return BlocBuilder<BerkasCubit, BerkasState>(
            builder: (context, state) {
              if (state is BerkasLoaded) {
                return Column(
                  children: [
                    WidgetImage(
                        title: "Berkas Surat Keterangan Belum Menikah",
                        image: berkasUlang ? null : menikah,
                        imageBase64: berkasUlang
                            ? null
                            : state.berkas.suratKeteranganBelumMenikah,
                        onTap: () {
                          setState(() async {
                            menikah = await getImage();
                          });
                        }),
                    WidgetImage(
                        title: "Berkas Surat Keterangan Masih Kuliah",
                        image: berkasUlang ? null : kuliah,
                        imageBase64: berkasUlang
                            ? null
                            : state.berkas.suratKeteranganMasihKuliah,
                        onTap: () {
                          setState(() async {
                            kuliah = await getImage();
                          });
                        }),
                    WidgetImage(
                        title: "Berkas Surat Keterangan Belum Bekerja",
                        image: berkasUlang ? null : bekerja,
                        imageBase64: berkasUlang
                            ? null
                            : state.berkas.suratKeteranganBelumBekerja,
                        onTap: () {
                          setState(() async {
                            bekerja = await getImage();
                          });
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
          listener: (context, berkasState) {
            // TODO: implement listener
            if (berkasState is BerkasPosted) {
              context
                  .read<BerkasCubit>()
                  .getBerkas(token: tokenBox.get('token'));
            }
          },
          builder: (context, berkasState) {
            return Column(
              children: [
                BlocBuilder<BerkasUlangCubit, bool>(
                  builder: (context, berkasUlang) {
                    return berkasState is BerkasLoaded
                        ? berkasUlang == false
                            ? berkasState.berkas.status == 4
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
                                            color: Colors.red.shade200),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            berkasState.berkas.alasan ?? '',
                                            style: tahomaR,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : berkasState.berkas.status == 2
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: getActualY(
                                                y: 12, context: context),
                                            horizontal: getActualX(
                                                x: defaultMargin,
                                                context: context)),
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: getActualX(
                                                x: 12, context: context),
                                            vertical: getActualY(
                                                y: 8, context: context)),
                                        decoration: BoxDecoration(
                                            boxShadow: [defaultBoxShadow],
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.blue.shade200),
                                            borderRadius:
                                                BorderRadius.circular(8)),
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
                            : const BoxGap()
                        : const BoxGap();
                  },
                ),
                BoxGap(
                  height: 8,
                ),
                BlocConsumer<DataPesertaCubit, DataPesertaState>(
                  listener: (context, state) {
                    print(state);
                    if (state is DataPesertaSuccess) {
                      print("kdProp");
                      print(kdProp);
                    }
                    if (state is DataPesertaUpdated) {
                      context
                          .read<DataPesertaCubit>()
                          .getDataPeserta(token: tokenBox.get('token'));
                      Navigator.pop(context);
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
                              Text(
                                'Saya',
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
                                data: 'Nomor e-DU',
                                value: state.data.noEdu,
                              ),
                              TextRapi(
                                data: 'Jenis Pensiun',
                                value: state.data.jnsPensiun,
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
                                'NIK',
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
                                'NPWP',
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
                              TextRapi(
                                data: 'a.\tNama Penerima Pensiun',
                                value: state.data.nmPenerimaMp,
                              ),
                              TextRapi(
                                data: '\t\t\t\tTempat, Tanggal Lahir',
                                value: state.data.tempatLahir! +
                                    ", " +
                                    state.data.tglLahir.toString(),
                              ),
                              TextRapi(
                                data: '\t\t\t\tNomor Pensiunan',
                                value: state.data.nip,
                              ),
                              const BoxGap(
                                height: 16,
                              ),
                              Text(
                                'b.\tUntuk pembayaran Manfaat Pensiun bulanan,\n\t\t\t\tmohon ditransfer ke:',
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "\t\t\t\t${state.data.nmBankPeserta} Cab ",
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "\t\t\t\t${state.data.noRekPeserta} ",
                                style: tahomaR.copyWith(
                                  fontSize: getActualY(y: 14, context: context),
                                  color: Colors.black,
                                ),
                              ),
                              const BoxGap(
                                height: 32,
                              ),
                              Text(
                                'Demikian pernyataan ini saya buat\ndengan sebenarnya, harap dapat dimaklumi. :',
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
                              state.data.jnsPensiun == "Pensiun Normal"
                                  ? BerkasBiasa()
                                  : state.data.jnsPensiun == "Janda"
                                      ? BerkasJanda()
                                      : BerkasAnak(),
                              const BoxGap(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: BlocBuilder<BerkasUlangCubit, bool>(
                                  builder: (context, berkasUlangState) {
                                    return berkasState is BerkasLoaded
                                        ? berkasUlangState == true ||
                                                berkasState.berkas.status == 0
                                            ? CustomButton(
                                                isLoading: state
                                                        is DataPesertaLoading ||
                                                    berkasState
                                                        is BerkasLoading,
                                                text: "Simpan",
                                                onPressed: () {
                                                  print(valueProp);
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    if (valueProp == null) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  content: Text(
                                                                    "Kolom provinsi tidak boleh kosong",
                                                                    style: tahomaR
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                  )));
                                                    } else {
                                                      if (state.data
                                                              .jnsPensiun ==
                                                          "Pensiun Normal") {
                                                        if (kk == null ||
                                                            ktp == null ||
                                                            npwp == null) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      content:
                                                                          Text(
                                                                        "Kolom Berkas KK, Berkas KTP dan Berkas NPWP tidak boleh kosong",
                                                                        style: tahomaR.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      )));
                                                        } else {
                                                          context.read<DataPesertaCubit>().updateDataPeserta(
                                                              token: tokenBox
                                                                  .get('token'),
                                                              edu: state
                                                                  .data.noEdu!,
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
                                                              pos:
                                                                  kdPosController
                                                                      .text,
                                                              nameKerabat:
                                                                  nameKerabatController
                                                                      .text,
                                                              telpKerabat:
                                                                  noTelpKerabatController
                                                                      .text);
                                                        }
                                                        var fileKTP =
                                                            File(ktp!.path);
                                                        var fileKK =
                                                            File(kk!.path);
                                                        var fileNPWP =
                                                            File(npwp!.path);
                                                        context
                                                            .read<BerkasCubit>()
                                                            .postBerkas(
                                                                token: tokenBox
                                                                    .get(
                                                                        'token'),
                                                                keys: [
                                                              'kk',
                                                              'ktp',
                                                              'npwp'
                                                            ],
                                                                files: [
                                                              fileKTP,
                                                              fileKK,
                                                              fileNPWP
                                                            ]);
                                                      } else if (state.data
                                                              .jnsPensiun ==
                                                          "Janda") {
                                                        if (kk == null ||
                                                            ktp == null ||
                                                            npwp == null ||
                                                            menikah == null) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      content:
                                                                          Text(
                                                                        "Kolom Berkas KK, Berkas KTP, Berkas NPWP dan Berkas Surat Keterangan Belum Menikah tidak boleh kosong",
                                                                        style: tahomaR.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      )));
                                                        } else {
                                                          context.read<DataPesertaCubit>().updateDataPeserta(
                                                              token: tokenBox
                                                                  .get('token'),
                                                              edu: state
                                                                  .data.noEdu!,
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
                                                              pos:
                                                                  kdPosController
                                                                      .text,
                                                              nameKerabat:
                                                                  nameKerabatController
                                                                      .text,
                                                              telpKerabat:
                                                                  noTelpKerabatController
                                                                      .text);
                                                          var fileKTP =
                                                              File(ktp!.path);
                                                          var fileKK =
                                                              File(kk!.path);
                                                          var fileNPWP =
                                                              File(npwp!.path);
                                                          var filemenikah =
                                                              File(menikah!
                                                                  .path);
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
                                                                'menikah'
                                                              ],
                                                                  files: [
                                                                fileKTP,
                                                                fileKK,
                                                                fileNPWP,
                                                                filemenikah
                                                              ]);
                                                        }
                                                      } else {
                                                        if (kuliah == null ||
                                                            bekerja == null ||
                                                            menikah == null) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      content:
                                                                          Text(
                                                                        "Kolom Berkas Keterangan Masih Kuliah, Berkas Surat Keterangan Belum Bekerja dan Berkas Surat Keterangan Belum Menikah tidak boleh kosong",
                                                                        style: tahomaR.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      )));
                                                        } else {
                                                          context.read<DataPesertaCubit>().updateDataPeserta(
                                                              token: tokenBox
                                                                  .get('token'),
                                                              edu: state
                                                                  .data.noEdu!,
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
                                                              pos:
                                                                  kdPosController
                                                                      .text,
                                                              nameKerabat:
                                                                  nameKerabatController
                                                                      .text,
                                                              telpKerabat:
                                                                  noTelpKerabatController
                                                                      .text);

                                                          var filemenikah =
                                                              File(menikah!
                                                                  .path);
                                                          var filebekerka =
                                                              File(bekerja!
                                                                  .path);
                                                          var fileKuliah = File(
                                                              kuliah!.path);

                                                          context
                                                              .read<
                                                                  BerkasCubit>()
                                                              .postBerkas(
                                                                  token: tokenBox
                                                                      .get('token'),
                                                                  keys: [
                                                                'kuliah',
                                                                'bekerja',
                                                                'menikah'
                                                              ],
                                                                  files: [
                                                                fileKuliah,
                                                                filebekerka,
                                                                filemenikah
                                                              ]);
                                                        }
                                                      }
                                                    }
                                                  }
                                                })
                                            : berkasState.berkas.status == 1
                                                ? Container()
                                                : berkasState.berkas.status == 4
                                                    ? CustomButton(
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  BerkasUlangCubit>()
                                                              .setValue(true);
                                                        },
                                                        text: "ULANGI",
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
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              16),
                                                                  height: 40,
                                                                  child:
                                                                      CustomButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    text: "OKE",
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8),
                                                                  height: 40,
                                                                  child:
                                                                      CustomButton(
                                                                    onPressed:
                                                                        () {
                                                                      // Navigator.pushReplacementNamed(context, '/unggah');
                                                                      context
                                                                          .read<
                                                                              BerkasUlangCubit>()
                                                                          .setValue(
                                                                              true);
                                                                    },
                                                                    fontTextSize:
                                                                        14,
                                                                    text:
                                                                        "UPDATE BERKAS",
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container()
                                        : Text("data");
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
