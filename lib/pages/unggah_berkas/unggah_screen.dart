// import 'package:dapenda/cubit/auth_cubit/auth_cubit.dart';
// import 'package:dapenda/cubit/berkas_cubit/berkas_cubit.dart';
// import 'package:dapenda/cubit/berkas_cubit/berkas_ulang_cubit.dart';
// import 'package:dapenda/cubit/data_peserta_cubit/data_peserta_cubit.dart';
// import 'package:dapenda/pages/unggah_berkas/petunjuk_blok.dart';
// import 'package:dapenda/pages/unggah_berkas/unggah-after.dart';
// import 'package:dapenda/pages/unggah_berkas/unggah-before.dart';
// import 'package:dapenda/pages/unggah_berkas/unggah-false.dart';
// import 'package:dapenda/pages/unggah_berkas/unggah-true.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive/hive.dart';

// import '../../themes/themes.dart';

// class UnggahScreen extends StatefulWidget {
//   const UnggahScreen({super.key});

//   @override
//   State<UnggahScreen> createState() => _UnggahScreenState();
// }

// class _UnggahScreenState extends State<UnggahScreen> {
//   bool petunjuk = true;

//   Box tokenBox = Hive.box('token');

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     var authState = context.read<AuthCubit>().state;
//     if (authState is AuthSuccess) {
//       print(authState.user.berkas1);
//       print(authState.user.berkas2);
//       print(authState.user.berkas1 == null || authState.user.berkas2 == null);
//       if (authState.user.berkas1 == null || authState.user.berkas2 == null) {
//         context.read<BerkasCubit>().getBerkas(token: '');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<BerkasUlangCubit, bool>(
//         builder: (context, ulangState) {
//           return BlocBuilder<DataPesertaCubit, DataPesertaState>(
//             builder: (context, dataPesertaState) {
//               if (dataPesertaState is DataPesertaSuccess) {
//                 return BlocConsumer<BerkasCubit, BerkasState>(
//                   listener: (context, berkasState) {
//                     print(berkasState);

//                     if (berkasState is BerkasPosted ||
//                         berkasState is BerkasFailed) {
//                       if (berkasState is BerkasFailed) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               berkasState.error,
//                               style: tahomaR.copyWith(
//                                 color: Colors.white,
//                               ),
//                             ),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                       context
//                           .read<BerkasCubit>()
//                           .getBerkas(token: tokenBox.get('token'));
//                     }
//                   },
//                   builder: (context, berkasState) {
//                     if (berkasState is BerkasLoaded) {
//                       return BlocBuilder<AuthCubit, AuthState>(
//                         builder: (context, state) {
//                           if (state is AuthSuccess) {
//                             if (ulangState) {
//                               return petunjuk
//                                   ? PetunjukBlok(onTap: () {
//                                       setState(() {
//                                         petunjuk = false;
//                                       });
//                                     })
//                                   : UnggahBefore(
//                                       data: dataPesertaState.data,
//                                       user: state.user,
//                                     );
//                             } else {
//                               if (berkasState.berkas.file1 == '' ||
//                                   berkasState.berkas.file2 == '') {
//                                 return petunjuk
//                                     ? PetunjukBlok(onTap: () {
//                                         setState(() {
//                                           petunjuk = false;
//                                         });
//                                       })
//                                     : UnggahBefore(
//                                         data: dataPesertaState.data,
//                                         user: state.user,
//                                       );
//                               } else {
//                                 // return Text(
//                                 // berkasState.berkas.verified.toString());
//                                 // if (berkasState.berkas.verified == false) {
//                                 //   if (berkasState.berkas.alasan == null) {
//                                 //     return UnggahAfter(
//                                 //         data: dataPesertaState.data,
//                                 //         user: state.user);
//                                 //   } else {
//                                 //     return UnggahFalse(
//                                 //         berkas: berkasState.berkas,
//                                 //         dataPeserta: dataPesertaState.data);
//                                 //   }
//                                 // } else {
//                                 //   return UnggahTrue(
//                                 //       berkas: berkasState.berkas,
//                                 //       dataPeserta: dataPesertaState.data);
//                                 // }

//                                 // } else {
//                                 // return UnggahAfter(
//                                 //     data: dataPesertaState.data,
//                                 //     user: state.user);
//                                 // }
//                                 // return BlocBuilder<DataPesertaCubit, DataPesertaState>(
//                                 //   builder: (context, dataPesertaState) {
//                                 //     print(dataPesertaState);
//                                 //     if (dataPesertaState is DataPesertaSuccess) {
//                                 //       return BlocBuilder<BerkasCubit, BerkasState>(
//                                 //         builder: (context, berkasState) {
//                                 //           if (berkasState is BerkasFailed) {
//                                 //             print(berkasState.error);
//                                 //           }
//                                 //           if (berkasState is BerkasLoaded) {
//                                 //             print("berkasState.berkas.verified");
//                                 //             print(berkasState.berkas.verified);
//                                 //             if (berkasState.berkas.verified!) {
//                                 //               if (berkasState.berkas.file1 == '' ||
//                                 //                   berkasState.berkas.file2 == '') {
//                                 //                 return UnggahTrue(
//                                 //                   dataPeserta: dataPesertaState.data,
//                                 //                   berkas: berkasState.berkas,
//                                 //                 );
//                                 //               } else {
//                                 //                 return UnggahFalse(
//                                 //                   dataPeserta: dataPesertaState.data,
//                                 //                   berkas: berkasState.berkas,
//                                 //                 );
//                                 //               }
//                                 //             } else {
//                                 //               return UnggahAfter(
//                                 //                 data: dataPesertaState.data,
//                                 //                 user: state.user,
//                                 //               );
//                                 //             }
//                                 //           } else {
//                                 //             return UnggahAfter(
//                                 //               data: dataPesertaState.data,
//                                 //               user: state.user,
//                                 //             );
//                                 //           }
//                                 //         },
//                                 //       );
//                                 //     } else {
//                                 //       return Center(
//                                 //         child: CircularProgressIndicator(),
//                                 //       );
//                                 //     }
//                                 //   },
//                                 // );
//                               }
//                             }
//                           } else {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                         },
//                       );
//                     } else {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   },
//                 );
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           );
//         },
//       ),
//     );
//   }
// }
