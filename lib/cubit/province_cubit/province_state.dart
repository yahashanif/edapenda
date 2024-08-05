part of 'province_cubit.dart';

sealed class ProvinceState extends Equatable {
  const ProvinceState();

  @override
  List<Object> get props => [];
}

final class ProvinceInitial extends ProvinceState {}

final class ProvinceLoading extends ProvinceState {}

final class ProvinceLoaded extends ProvinceState {
  final List<Province> province;
  const ProvinceLoaded({required this.province});
}

final class ProvinceFailed extends ProvinceState {
  final String error;
  const ProvinceFailed({required this.error});
}
