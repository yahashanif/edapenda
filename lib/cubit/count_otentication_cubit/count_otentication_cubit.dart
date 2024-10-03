import 'package:flutter_bloc/flutter_bloc.dart';

class CountOtenticationCubit extends Cubit<int> {
  CountOtenticationCubit() : super(0);

  void setValue() => emit(state + 1);
}
