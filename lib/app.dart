import 'dart:io';

import 'package:dapenda/app/routes.dart';
import 'package:dapenda/cubit/auth_cubit/auth_cubit.dart';
import 'package:dapenda/cubit/berkas_cubit/berkas_cubit.dart';
import 'package:dapenda/cubit/province_cubit/province_cubit.dart';
import 'package:dapenda/cubit/berkas_cubit/berkas_ulang_cubit.dart';
import 'package:dapenda/cubit/data_peserta_cubit/data_peserta_cubit.dart';
import 'package:dapenda/cubit/faq_cubit/faq_cubit.dart';
import 'package:dapenda/cubit/value_pendataan_foto_cubit/value_pendataan_foto_cubit.dart';
import 'package:dapenda/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/notification_manager.dart';
import 'cubit/count_otentication_cubit/count_otentication_cubit.dart';
import 'cubit/image_cubit/current_image_cubit.dart';
import 'cubit/pendataan_foto_cubit/pendataan_foto_cubit.dart';
import 'cubit/pendataan_foto_matrik_cubit/pendataan_foto_matrik_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    // FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    //   if (Platform.isIOS) {
    //   } else {
    //     NotificationManager().showNotification(
    //         title: message!.notification!.title!,
    //         body: message!.notification!.body!);
    //     print(message!.data);
    //   }
    //   //   // showFlutterNotification(message);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CurrentImageCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => DataPesertaCubit()),
        BlocProvider(create: (_) => BerkasCubit()),
        BlocProvider(create: (_) => BerkasUlangCubit()),
        BlocProvider(create: (_) => ValuePendataanFotoCubit()),
        BlocProvider(create: (_) => PendataanFotoCubit()),
        BlocProvider(create: (_) => FaqCubit()),
        BlocProvider(create: (_) => ProvinceCubit()),
        BlocProvider(create: (_) => PendataanFotoMatrikCubit()),
        BlocProvider(create: (_) => CountOtenticationCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: green,
            // primaryColor,
            // ···
            brightness: Brightness.light,
          ),
        ),
        initialRoute: splashRoute,
        onGenerateRoute: AppRoute().generateRoute,
      ),
    );
  }
}
