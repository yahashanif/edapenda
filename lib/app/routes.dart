import 'package:dapenda/pages/bantuan/bantuan_screen.dart';
import 'package:dapenda/pages/data_ulang/data_ulang_screen.dart';
import 'package:dapenda/pages/home/home_screen.dart';
import 'package:dapenda/pages/login/login_screen.dart';
import 'package:dapenda/pages/on_boarding/on_boarding_screen.dart';
import 'package:dapenda/pages/otentikasi/otentikasi_screen.dart';
import 'package:dapenda/pages/pendataan_foto/pendataan_camera_screen.dart';
import 'package:dapenda/pages/pendataan_foto/pendataan_foto_screen.dart';
import 'package:dapenda/pages/recognation/camera_screen.dart';
import 'package:dapenda/pages/recognation/recognation_screen.dart';
import 'package:dapenda/pages/unggah_berkas/unggah_screen.dart';
import 'package:flutter/material.dart';

import '../pages/splash_screen/splash_screen.dart';

const String splashRoute = '/';

const String onBoardingRoute = '/onBoarding';

const String loginRoute = '/login';

const String homeRoute = '/home';

const String dataUlangRoute = '/data-ulang';

const String unggahBerkasRoute = '/unggah-berkas';

const String pendataanFotoRoute = '/pendataan-foto';

const String otentikasiRoute = '/otentikasi';

const String recognationRoute = '/recognation';

const String pendataanCameraRoute = '/pendataan-camera';

const String cameraRoute = '/camera';

const String bantuanRoute = '/help';

class AppRoute {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case onBoardingRoute:
        return MaterialPageRoute(
            builder: (context) => const OnBoardingScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case dataUlangRoute:
        return MaterialPageRoute(builder: (context) => const DataUlangScreen());
      case unggahBerkasRoute:
        return MaterialPageRoute(builder: (context) => const UnggahScreen());
      case pendataanFotoRoute:
        return MaterialPageRoute(
            builder: (context) => const PendataanFotoScreen());
      case pendataanCameraRoute:
        return MaterialPageRoute(
            builder: (context) => const PendataanCameraScreen());
      case recognationRoute:
        return MaterialPageRoute(
            builder: (context) => const RecognationScreen());
      case cameraRoute:
        List<double>? argumen;
        if (settings.arguments != null) {
          argumen = settings.arguments as List<double>;
        }
        return MaterialPageRoute(
            builder: (context) => CameraScreen(
                  embedding: argumen ?? [],
                ));

      case bantuanRoute:
        return MaterialPageRoute(builder: (context) => const BantuanScreen());
      case otentikasiRoute:
        return MaterialPageRoute(
            builder: (context) => const OtentikasiScreen());

      default:
        return MaterialPageRoute(
            builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: const Scaffold()));
    }
  }
}
