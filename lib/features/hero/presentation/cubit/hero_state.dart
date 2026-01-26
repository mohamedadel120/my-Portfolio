import 'package:equatable/equatable.dart';
import '../../domain/entities/hero_entity.dart';

abstract class HeroState extends Equatable {
  const HeroState();

  @override
  List<Object> get props => [];
}

class HeroInitial extends HeroState {}

class HeroLoading extends HeroState {}

class HeroLoaded extends HeroState {
  final HeroData heroData;

  const HeroLoaded(this.heroData);

  @override
  List<Object> get props => [heroData];
}

class HeroError extends HeroState {
  final String message;

  const HeroError(this.message);

  @override
  List<Object> get props => [message];
}
