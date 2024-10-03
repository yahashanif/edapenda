import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/berkas.dart';
import '../../repository/berkas_repository.dart';

part 'berkas_state.dart';

class BerkasCubit extends Cubit<BerkasState> {
  BerkasCubit() : super(BerkasInitial());

  void getBerkas({required String token}) async {
    try {
      emit(BerkasLoading());
      final berkas = await BerkasRepository().getBerkas(token: token);
      emit(BerkasLoaded(berkas: berkas));
    } catch (e) {
      emit(BerkasFailed(error: e.toString()));
    }
  }

  void postBerkas(
      {required String token,
      required List<File> files,
      required List<String> keys}) async {
    try {
      emit(BerkasLoading());
      await BerkasRepository().updateBerkas(
        token: token,
        keys: keys,
        files: files,
      );
      emit(BerkasPosted());
    } catch (e) {
      emit(BerkasFailed(error: e.toString()));
    }
  }
}
