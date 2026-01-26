import 'package:equatable/equatable.dart';
import '../../domain/entities/about_entity.dart';

abstract class AboutState extends Equatable {
  const AboutState();

  @override
  List<Object> get props => [];
}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutLoaded extends AboutState {
  final AboutData aboutData;

  const AboutLoaded(this.aboutData);

  @override
  List<Object> get props => [aboutData];
}

class AboutError extends AboutState {
  final String message;

  const AboutError(this.message);

  @override
  List<Object> get props => [message];
}
