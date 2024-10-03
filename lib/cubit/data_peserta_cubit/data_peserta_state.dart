part of 'data_peserta_cubit.dart';

@immutable
sealed class DataPesertaState {}

final class DataPesertaInitial extends DataPesertaState {}

final class DataPesertaLoading extends DataPesertaState {}

final class DataPesertaUpdated extends DataPesertaState {}

final class DataPesertaSuccess extends DataPesertaState {
  final DataPeserta data;

  DataPesertaSuccess({required this.data});
}

final class DataPesertaFailed extends DataPesertaState {
  final String error;

  DataPesertaFailed({required this.error});
}
