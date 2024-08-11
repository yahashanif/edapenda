part of 'cek_otentikasi_cubit.dart';

@immutable
sealed class CekOtentikasiState {}

final class CekOtentikasiInitial extends CekOtentikasiState {}

final class CekOtentikasiLoading extends CekOtentikasiState {}

final class CekOtentikasiPosted extends CekOtentikasiState {}

final class CekOtentikasiLoaded extends CekOtentikasiState {
  final CekOtentikasi otentikasi;

  CekOtentikasiLoaded({required this.otentikasi});
}

final class CekOtentikasiFailed extends CekOtentikasiState {
  final String error;

  CekOtentikasiFailed({required this.error});
}
