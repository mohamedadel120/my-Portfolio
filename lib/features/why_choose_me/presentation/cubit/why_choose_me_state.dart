import 'package:equatable/equatable.dart';
import '../../../../models/why_choose_me_reason.dart';

abstract class WhyChooseMeState extends Equatable {
  const WhyChooseMeState();

  @override
  List<Object> get props => [];
}

class WhyChooseMeInitial extends WhyChooseMeState {}

class WhyChooseMeLoading extends WhyChooseMeState {}

class WhyChooseMeLoaded extends WhyChooseMeState {
  final List<WhyChooseMeReason> reasons;

  const WhyChooseMeLoaded(this.reasons);

  @override
  List<Object> get props => [reasons];
}

class WhyChooseMeError extends WhyChooseMeState {
  final String message;

  const WhyChooseMeError(this.message);

  @override
  List<Object> get props => [message];
}
