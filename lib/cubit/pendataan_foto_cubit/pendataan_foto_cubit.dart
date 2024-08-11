import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/pendataan_foto.dart';
import '../../repository/pendataan_foto_repository.dart';

part 'pendataan_foto_state.dart';

class PendataanFotoCubit extends Cubit<PendataanFotoState> {
  PendataanFotoCubit() : super(PendataanFotoInitial());

  void pendataanFotoPost(
      {required String token,
      required List<double> matriks,
      required File file}) async {
    try {
      emit(PendataanFotoLoading());
      await PendataanFotoRepository()
          .pendataanFotoPost(token: token, matriks: matriks, file: file);
      emit(PendataanFotoPosted());
    } catch (e) {
      emit(PendataanFotoFailed(error: e.toString()));
    }
  }

  void pendataanFotoGet({required String token}) async {
    try {
      emit(PendataanFotoLoading());
      final data =
          await PendataanFotoRepository().getPendataanFoto(token: token);
      emit(PendataanFotoLoaded(pendataanFoto: data));
    } catch (e) {
      print(e.toString());
      emit(PendataanFotoFailed(error: e.toString()));
    }
  }
}
