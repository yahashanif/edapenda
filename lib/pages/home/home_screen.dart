import 'package:dapenda/app/notification_manager.dart';
import 'package:dapenda/app/routes.dart';
import 'package:dapenda/cubit/auth_cubit/auth_cubit.dart';
import 'package:dapenda/cubit/berkas_cubit/berkas_cubit.dart';
import 'package:dapenda/cubit/data_peserta_cubit/data_peserta_cubit.dart';
import 'package:dapenda/cubit/faq_cubit/faq_cubit.dart';
import 'package:dapenda/cubit/pendataan_foto_cubit/pendataan_foto_cubit.dart';
import 'package:dapenda/cubit/pendataan_foto_matrik_cubit/pendataan_foto_matrik_cubit.dart';
import 'package:dapenda/cubit/province_cubit/province_cubit.dart';
import 'package:dapenda/pages/home/HomeShimmer.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../app/constant.dart';
import '../../cubit/berkas_cubit/berkas_ulang_cubit.dart';
import '../../cubit/value_pendataan_foto_cubit/value_pendataan_foto_cubit.dart';
import '../../repository/ml_service.dart';
import '../../themes/themes.dart';
import '../../widgets/menu.dart';
import 'carousel_slider_berita.dart';
import 'detail_profil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController controller = PageController(initialPage: 0);
  int currentPageValue = 0;
  Box tokenBox = Hive.box('token');
  bool initBerkas = true;

  // final GlobalKey<RefreshIndicatorState> _key =
  //     GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    NotificationManager().RequestPermissions();
    // TODO: implement initState
    super.initState();
    context.read<ProvinceCubit>().getProvince(token: tokenBox.get("token"));
    context
        .read<PendataanFotoMatrikCubit>()
        .getPendataanFotoMatrik(token: tokenBox.get('token'));

    context
        .read<DataPesertaCubit>()
        .getDataPeserta(token: tokenBox.get("token"));

    context
        .read<PendataanFotoCubit>()
        .pendataanFotoGet(token: tokenBox.get('token'));
    context.read<BerkasCubit>().getBerkas(token: tokenBox.get('token'));
  }

  @override
  Widget build(BuildContext context) {
    Widget indicator(bool isActive, page) {
      return GestureDetector(
        onTap: () {
          controller.animateToPage(page,
              duration: const Duration(seconds: 1), curve: Curves.easeOut);
        },
        child: SizedBox(
          height: getActualY(y: 10, context: context),
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 4.0),
            height: isActive
                ? getActualY(y: 18, context: context)
                : getActualY(y: 16, context: context),
            width: isActive
                ? getActualX(x: 20, context: context)
                : getActualX(x: 16, context: context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? blue : const Color(0XFFEAEAEA),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppbar(
        title: "E-DAPENDA",
        centerTitle: false,
        backgroundColor: blue,
        actionWidget: [
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, loginRoute, (route) => false);
                tokenBox.delete("token");
              },
              child: Text(
                "Keluar",
                style: robotoM.copyWith(
                    fontSize: getActualY(y: 20, context: context),
                    color: Colors.white),
              ))
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            Navigator.pushReplacementNamed(context, loginRoute);
          }
        },
        builder: (context, state) {
          if (state is AuthSuccess) {
            return RefreshIndicator(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getActualX(x: 10, context: context),
                        vertical: getActualY(y: 16, context: context)),
                    child: Column(
                      children: [
                        // CarouselSliderBerita(
                        //   controller: controller,
                        //   onSlide: (page) {
                        //     // setState(() {
                        //     //   currentPageValue = page;
                        //     // });
                        //   },
                        // ),
                        // const BoxGap(height: 8),
                        const BoxGap(height: 16),
                        DetailProfil(user: state.user),
                        BlocBuilder<PendataanFotoCubit, PendataanFotoState>(
                          builder: (context, state) {
                            print(state);
                            // if (state is PendataanFotoLoaded) {
                            //   if (state.pendataanFoto.foto == null) {
                            //     return Menu(
                            //       func: () {
                            //         Navigator.pushNamed(
                            //             context, pendataanFotoRoute);
                            //         context
                            //             .read<ValuePendataanFotoCubit>()
                            //             .setValue(null);
                            //       },
                            //       title: 'Pendataan Foto',
                            //       image: 'pendataan',
                            //       subtitle:
                            //           'Anda Belum Melakukan\nPendataan Foto',
                            //     );
                            //   } else {
                            //     if (state.pendataanFoto.verified!) {
                            //       return Menu(
                            //         title: "Pendataan Foto",
                            //         image: "success",
                            //         subtitle: "Pendataan Foto Berhasil",
                            //       );
                            //     } else {
                            //       if (state.pendataanFoto.foto != null) {
                            //         return Menu(
                            //           title: "Pendataan Foto",
                            //           image: "success",
                            //           subtitle:
                            //               "Anda Sudah Melakukan Pendataan Foto\nSilahkan Tunggu Konfirmasi 1 x 24 Jam",
                            //         );
                            //       } else {
                            //         return Menu(
                            //           title: "Pendataan Foto",
                            //           image: 'pendataan',
                            //           subtitle:
                            //               "Pendataan foto anda tidak sesuai\nsilahkan ulangi pendataan",
                            //           func: () {
                            //             Navigator.pushNamed(
                            //                 context, pendataanFotoRoute);
                            //             context
                            //                 .read<ValuePendataanFotoCubit>()
                            //                 .setValue(null);
                            //           },
                            //         );
                            //       }
                            //     }
                            //   }
                            // } else {
                            return Menu(
                              func: () {
                                Navigator.pushNamed(
                                    context, pendataanFotoRoute);
                                context
                                    .read<ValuePendataanFotoCubit>()
                                    .setValue(null);
                              },
                              title: 'Pendataan Foto',
                              image: 'pendataan',
                              subtitle: 'Anda Belum Melakukan\nPendataan Foto',
                            );
                            // }
                          },
                        ),
                        BlocBuilder<PendataanFotoMatrikCubit,
                            PendataanFotoMatrikState>(
                          builder: (context, state) {
                            print(state);
                            return (state is PendataanFotoMatrikLoading)
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: blue,
                                    ),
                                  )
                                : Menu(
                                    func: () {
                                      Navigator.pushNamed(
                                          context, otentikasiRoute);
                                      // _statusFotoAwal == 'false'
                                      //     ? _buildShowDialogOtentikasi(context)
                                      //     : Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //           builder: (context) => Otentikasi(),
                                      //         ),
                                      //       );
                                    },
                                    title: 'Otentikasi',
                                    subtitle:
                                        'Silakan Lakukan Otentikasi\ndisini.',
                                    image: 'otentikasi',
                                  );
                          },
                        ),
                        BlocBuilder<BerkasCubit, BerkasState>(
                          builder: (context, state) {
                            return Menu(
                              func: () {
                                Navigator.pushNamed(context, dataUlangRoute);
                              },
                              // state is BerkasLoaded
                              //     ? state.berkas.file1 == '' ||
                              //             state.berkas.file2 == ''
                              //         ? () {
                              //             Navigator.pushNamed(
                              //                 context, dataUlangRoute);
                              //           }
                              //         : state.berkas.verified == true
                              //             ? () {
                              //                 Navigator.pushNamed(
                              //                     context, dataUlangRoute);
                              //               }
                              //             : state.berkas.verified == false &&
                              //                     state.berkas.status == true
                              //                 ? null
                              //                 : null
                              //     : null,

                              // state is BerkasLoaded
                              //     ? state.berkas.file1 == '' ||
                              //             state.berkas.file2 == ''
                              // ? () {
                              //     Navigator.pushNamed(
                              //         context, dataUlangRoute);
                              //   }
                              //         : null
                              //     : null,
                              title: 'Data Ulang',
                              subtitle: state is BerkasLoaded
                                  ? state.berkas.file1 == '' ||
                                          state.berkas.file2 == ''
                                      ? 'Anda Belum Mengunggah Berkas\nData Ulang'
                                      : state.berkas.verified == true
                                          ? 'Jika ada perubahan, Silakan\nlakukan disini.'
                                          : state.berkas.verified == false &&
                                                  state.berkas.status == true
                                              ? "Menunggu Verifikasi Berkas\nData Ulang"
                                              : "Verifikasi Berkas\nData Ulang Gagal"
                                  : '',
                              image: 'data',
                            );
                          },
                        ),
                        // BlocConsumer<BerkasCubit, BerkasState>(
                        //   builder: (context, berkasState) {
                        //     print(berkasState);
                        //     return Menu(
                        //       func: () {
                        //         initBerkas = true;
                        //         context
                        //             .read<BerkasUlangCubit>()
                        //             .setValue(false);

                        //         context.read<DataPesertaCubit>().getDataPeserta(
                        //             token: tokenBox.get('token'));
                        //         context
                        //             .read<BerkasCubit>()
                        //             .getBerkas(token: tokenBox.get('token'));
                        //       },
                        //       title: 'Unggah Berkas\nData Ulang',
                        //       subtitle:
                        //           'Unggah berkas kelengkapan\ndata ulang Anda disini.',
                        //       image: 'data',
                        //     );
                        //   },
                        //   listener: (context, berkasState) {
                        //     if (berkasState is BerkasFailed) {
                        //       print(berkasState.error);
                        //     }
                        //     if (berkasState is BerkasLoaded) {
                        //       if (initBerkas) {
                        //         print(state.user.berkas1);

                        //         if (state.user.berkas1 == '' ||
                        //             state.user.berkas2 == '') {
                        //           Navigator.pushNamed(
                        //               context, unggahBerkasRoute);
                        //         } else {
                        //           _buildShowDialog(
                        //             context,
                        //             'Terimakasih Anda sudah melakukan Unggah Berkas.',
                        //             unggahBerkasRoute,
                        //           );
                        //         }
                        //         initBerkas = false;
                        //       }
                        //     }
                        //     // if (_statusBerkas) {

                        //     // } else {
                        //     // Navigator.push(
                        //     //   context,
                        //     //   MaterialPageRoute(
                        //     //     builder: (context) => Unggah(),
                        //     //   ),
                        //     // );
                        //     // }
                        //   },
                        // ),
                        Menu(
                          func: () {
                            Navigator.pushNamed(context, bantuanRoute);
                            context
                                .read<FaqCubit>()
                                .getFaq(token: tokenBox.get('token'));
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => Bantuan()));
                          },
                          title: 'Bantuan',
                          subtitle: 'Pusat Bantuan.',
                          image: 'bantuan',
                        ),
                        const BoxGap(height: 8),
                        Text('copyright © e-DAPENDA 2020 - versi 1.2',
                            style: robotoM.copyWith(color: Colors.grey))
                      ],
                    ),
                  ),
                ),
                onRefresh: () async {});
          }
          return HomeShimmer();
        },
      ),
    );
  }

  _buildShowDialog(BuildContext context, String text, String route) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        content: Text(
          text,
          style: tahomaR.copyWith(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Container(
              width: 70,
              margin: EdgeInsets.only(right: 8, bottom: 4),
              child: CustomButton(
                  text: "Oke",
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.popAndPushNamed(context, unggahBerkasRoute);
                  }))
        ],
      ),
    );
  }
}
