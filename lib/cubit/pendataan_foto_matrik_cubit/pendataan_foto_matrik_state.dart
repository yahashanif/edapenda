part of 'pendataan_foto_matrik_cubit.dart';

@immutable
sealed class PendataanFotoMatrikState {}

final class PendataanFotoMatrikInitial extends PendataanFotoMatrikState {}

final class PendataanFotoMatrikLoading extends PendataanFotoMatrikState {}

final class PendataanFotoMatrikLoaded extends PendataanFotoMatrikState {
  final List<PendataanFotoMatrik> list;

  PendataanFotoMatrikLoaded({required this.list});
}

final class PendataanFotoMatrikFailed extends PendataanFotoMatrikState {
  final String error;

  PendataanFotoMatrikFailed({required this.error});
}
