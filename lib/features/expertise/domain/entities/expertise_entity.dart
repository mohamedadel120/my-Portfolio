import 'package:equatable/equatable.dart';

class Expertise extends Equatable {
  final String title;
  final String description;
  final String iconKey;
  final int? color;

  const Expertise({
    required this.title,
    required this.description,
    required this.iconKey,
    this.color,
  });

  @override
  List<Object?> get props => [title, description, iconKey, color];
}
