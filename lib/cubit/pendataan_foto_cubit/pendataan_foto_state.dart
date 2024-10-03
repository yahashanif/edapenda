part of 'pendataan_foto_cubit.dart';

@immutable
sealed class PendataanFotoState {}

final class PendataanFotoInitial extends PendataanFotoState {}

final class PendataanFotoLoading extends PendataanFotoState {}

final class PendataanFotoLoaded extends PendataanFotoState {
  final PendataanFoto pendataanFoto;

  PendataanFotoLoaded({required this.pendataanFoto});
}

final class PendataanFotoPosted extends PendataanFotoState {}

final class PendataanFotoFailed extends PendataanFotoState {
  final String error;

  PendataanFotoFailed({required this.error});
}
