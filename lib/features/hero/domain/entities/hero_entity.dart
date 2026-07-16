import 'package:equatable/equatable.dart';

class HeroData extends Equatable {
  final String name;
  final String title;
  final String subtitle;
  final String helloGreeting;
  final bool showAurora;
  final String cvUrl;

  const HeroData({
    required this.name,
    required this.title,
    required this.subtitle,
    required this.helloGreeting,
    required this.showAurora,
    required this.cvUrl,
  });

  @override
  List<Object?> get props =>
      [name, title, subtitle, helloGreeting, showAurora, cvUrl];
}
