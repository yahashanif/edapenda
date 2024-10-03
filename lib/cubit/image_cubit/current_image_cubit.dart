import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CurrentImageCubit extends Cubit<XFile?> {
  CurrentImageCubit() : super(null);

  void setXFile(XFile? xfile) => emit(xfile);
}
