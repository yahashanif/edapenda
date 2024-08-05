import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/data_auth.dart';
import '../../repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login({required String edu, required String tokenFcm}) async {
    try {
      emit(AuthLoading());
      final result = await AuthRepository().login(edu: edu, tokenFcm: tokenFcm);
      // await Future.delayed(Duration(seconds: 5));
      emit(AuthSuccess(user: result));
    } catch (e) {
      print(e.toString());
      emit(AuthFailed(error: e.toString()));
    }
  }

  void syncAkun({required String token}) async {
    try {
      emit(AuthLoading());
      final result = await AuthRepository().syncAkun(token: token);
      emit(AuthSuccess(user: result));
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }
}
