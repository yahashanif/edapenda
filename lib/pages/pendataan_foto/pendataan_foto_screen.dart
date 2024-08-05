import 'package:dapenda/themes/themes.dart';
import 'package:dapenda/widgets/base_appbar.dart';
import 'package:flutter/material.dart';

import 'pendataan_baru.dart';

class PendataanFotoScreen extends StatelessWidget {
  const PendataanFotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppbar(
        title: "Pendataan Foto",
        backgroundColor: blue,
      ),
      body: Container(
          child:
              // Blok Pendataan Baru
              // Blok Pendataan Setelah Upload,
              // Blok Pendataan Setelah Validasi
              // Blok Pendataan gagal Validasi
              PendataanBaru()),
    );
  }
}
