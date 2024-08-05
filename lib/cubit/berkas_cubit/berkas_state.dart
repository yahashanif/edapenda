part of 'berkas_cubit.dart';

@immutable
sealed class BerkasState {}

final class BerkasInitial extends BerkasState {}

final class BerkasLoading extends BerkasState {}

final class BerkasPosted extends BerkasState {}

final class BerkasLoaded extends BerkasState {
  final Berkas berkas;

  BerkasLoaded({required this.berkas});
}

final class BerkasFailed extends BerkasState {
  final String error;

  BerkasFailed({required this.error});
}
