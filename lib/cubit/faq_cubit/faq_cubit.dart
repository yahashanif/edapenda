import 'package:dapenda/model/faq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/faq_repository.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit() : super(FaqInitial());

  void getFaq({required String token}) async {
    try {
      emit(FaqLoading());
      final data = await FAQRepository().getFAQ(token: token);
      emit(FaqLoaded(list: data));
    } catch (e) {
      emit(FaqFailed(error: e.toString()));
    }
  }
}
