import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liveness_detection_flutter_plugin/index.dart';

import '../../model/province.dart';
import '../../repository/province_repository.dart';

part 'province_state.dart';

class ProvinceCubit extends Cubit<ProvinceState> {
  ProvinceCubit() : super(ProvinceInitial());

  void getProvince({required String token}) async {
    try {
      emit(ProvinceLoading());

      final province = await ProvinceRepository().getProvince(token: token);
      emit(ProvinceLoaded(province: province));
    } catch (e) {
      emit(ProvinceFailed(error: e.toString()));
    }
  }
}
