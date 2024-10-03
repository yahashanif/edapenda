import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/data_peserta.dart';
import '../../repository/data_peserta_repository.dart';

part 'data_peserta_state.dart';

class DataPesertaCubit extends Cubit<DataPesertaState> {
  DataPesertaCubit() : super(DataPesertaInitial());
  void getDataPeserta({required String token}) async {
    try {
      emit(DataPesertaLoading());
      final data = await DataPesertaRepository().getDataPeserta(token: token);
      emit(DataPesertaSuccess(data: data));
    } catch (e) {
      emit(DataPesertaFailed(error: e.toString()));
    }
  }

  Future<void> updateDataPeserta({
    required String token,
    required String edu,
    required String kegiatan,
    required String alamat,
    required String telp,
    required String hp,
    required String prop,
    required String nik,
    String npwp = '',
    required String pos,
    required String nameKerabat,
    required String telpKerabat,
  }) async {
    try {
      emit(DataPesertaLoading());
      final response = await DataPesertaRepository().updateDataPeserta(
        token: token,
        edu: edu,
        kegiatan: kegiatan,
        alamat: alamat,
        telp: telp,
        hp: hp,
        prop: prop,
        nik: nik,
        npwp: npwp,
        pos: pos,
        nameKerabat: nameKerabat,
        telpKerabat: telpKerabat,
      );
      emit(DataPesertaUpdated());
      // await Future.delayed(Duration(seconds: 2));
      // if (response) {
      //   emit(DataPesertaUpdated());
      // } else {
      //   emit(DataPesertaFailed(error: "Gagal Update Data Ulang"));
      // }
    } catch (e) {
      emit(DataPesertaFailed(error: e.toString()));
    }
  }
}
