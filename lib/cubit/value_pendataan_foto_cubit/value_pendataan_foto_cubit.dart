import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ValuePendataanFotoCubit extends Cubit<List<double>?> {
  ValuePendataanFotoCubit() : super(null);

  void setValue(List<double>? value) => emit(value);
}
