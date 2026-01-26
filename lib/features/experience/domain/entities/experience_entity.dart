import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final String company;
  final String role;
  final String period;
  final List<String> achievements;

  const Experience({
    required this.company,
    required this.role,
    required this.period,
    required this.achievements,
  });

  @override
  List<Object> get props => [company, role, period, achievements];
}
