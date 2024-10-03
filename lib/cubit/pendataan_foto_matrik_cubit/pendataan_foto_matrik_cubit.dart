import 'package:dapenda/model/peserta_foto_matrik.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/pendataan_foto_repository.dart';

part 'pendataan_foto_matrik_state.dart';

class PendataanFotoMatrikCubit extends Cubit<PendataanFotoMatrikState> {
  PendataanFotoMatrikCubit() : super(PendataanFotoMatrikInitial());

  void getPendataanFotoMatrik({required String token}) async {
    try {
      emit(PendataanFotoMatrikLoading());
      final data =
          await PendataanFotoRepository().getPendataanFotoMatrik(token: token);
      emit(PendataanFotoMatrikLoaded(list: data));
    } catch (e) {
      emit(PendataanFotoMatrikFailed(error: e.toString()));
    }
  }
}
