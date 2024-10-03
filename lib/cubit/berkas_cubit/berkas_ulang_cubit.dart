import 'package:flutter_bloc/flutter_bloc.dart';

class BerkasUlangCubit extends Cubit<bool> {
  BerkasUlangCubit() : super(false);

  void setValue(bool value) => emit(value);
}
