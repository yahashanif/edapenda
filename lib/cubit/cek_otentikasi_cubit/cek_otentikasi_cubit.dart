import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dapenda/model/cek_otentikasi.dart';
import 'package:dapenda/repository/otentication_repository.dart';
import 'package:meta/meta.dart';

part 'cek_otentikasi_state.dart';

class CekOtentikasiCubit extends Cubit<CekOtentikasiState> {
  CekOtentikasiCubit() : super(CekOtentikasiInitial());

  void cekOtentikasi({required String token}) async {
    emit(CekOtentikasiLoading());
    try {
      CekOtentikasi otentikasi = await OtenticationRepository().cekOtentikasi(
        token: token,
      );
      emit(CekOtentikasiLoaded(otentikasi: otentikasi));
    } catch (e) {
      emit(CekOtentikasiFailed(error: e.toString()));
    }
  }

  void postOtentikasi(
      {required String token,
      required bool verified,
      required File file}) async {
    try {
      emit(CekOtentikasiLoading());
      await OtenticationRepository().postOtentication(
        token: token,
        verified: verified,
        file: file,
      );
      emit(CekOtentikasiPosted());
    } catch (e) {
      emit(CekOtentikasiFailed(error: e.toString()));
    }
  }
}
