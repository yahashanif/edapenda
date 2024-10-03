part of 'faq_cubit.dart';

@immutable
sealed class FaqState {}

final class FaqInitial extends FaqState {}

final class FaqLoading extends FaqState {}

final class FaqLoaded extends FaqState {
  final List<FAQModel> list;

  FaqLoaded({required this.list});
}

final class FaqFailed extends FaqState {
  final String error;

  FaqFailed({required this.error});
}
