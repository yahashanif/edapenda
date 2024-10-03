// import 'package:dapenda/cubit/berkas_cubit/berkas_ulang_cubit.dart';
// import 'package:dapenda/model/berkas.dart';
// import 'package:dapenda/model/data_peserta.dart';
// import 'package:dapenda/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../themes/themes.dart';
// import '../../widgets/base_appbar.dart';
// import '../../widgets/text-rapi.dart';

// class UnggahTrue extends StatefulWidget {
//   final DataPeserta dataPeserta;
//   final Berkas berkas;

//   const UnggahTrue(
//       {super.key, required this.berkas, required this.dataPeserta});

//   @override
//   _UnggahTrueState createState() => _UnggahTrueState();
// }

// class _UnggahTrueState extends State<UnggahTrue> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const BaseAppbar(
//         title: "Kembali",
//         backgroundColor: blue,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.only(left: 16, top: 40, right: 16, bottom: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/images/success.png'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Text(
//                     'Validasi Berkas Berhasil',
//                     style: tahomaB.copyWith(
//                       fontSize: 20,
//                       color: Color(0XFF9AD25C),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 48),
//               TextRapi(
//                 data: 'Nama Penerima Pensiun',
//                 value: widget.dataPeserta.nmPenerimaMp,
//               ),
//               TextRapi(
//                 data: 'Nomor eDU',
//                 value: widget.dataPeserta.noEdu,
//               ),
//               TextRapi(
//                 data: 'Nomor Pensiunan / NIP',
//                 value: widget.dataPeserta.nip,
//               ),
//               TextRapi(
//                 data: 'Jenis Pensiun',
//                 value: widget.dataPeserta.jnsPensiun,
//               ),
//               SizedBox(height: 32),
//               Text(
//                 'Foto KTP',
//                 style: tahomaR.copyWith(
//                   color: Color(0XFF757575),
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(widget.berkas.file1!),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Foto Kartu KK',
//                 style: tahomaR.copyWith(
//                   color: Color(0XFF757575),
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(widget.berkas.file2!),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 32),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       height: 40,
//                       child: CustomButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         text: "OKE",
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8),
//                       height: 40,
//                       child: CustomButton(
//                         onPressed: () {
//                           // Navigator.pushReplacementNamed(context, '/unggah');
//                           context.read<BerkasUlangCubit>().setValue(true);
//                         },
//                         fontTextSize: 14,
//                         text: "UPDATE BERKAS",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
