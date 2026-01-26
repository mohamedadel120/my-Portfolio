import 'package:equatable/equatable.dart';

class ContactData extends Equatable {
  final String title;
  final String subtitle;
  final String email;
  final String phone;
  final String location;
  final List<SocialLink> socialLinks;

  const ContactData({
    required this.title,
    required this.subtitle,
    required this.email,
    required this.phone,
    required this.location,
    required this.socialLinks,
  });

  @override
  List<Object?> get props =>
      [title, subtitle, email, phone, location, socialLinks];
}

class SocialLink extends Equatable {
  final String name; // Email, GitHub, LinkedIn
  final String url;
  final String iconCode; // Map to IconData

  const SocialLink({
    required this.name,
    required this.url,
    required this.iconCode,
  });

  @override
  List<Object?> get props => [name, url, iconCode];
}
