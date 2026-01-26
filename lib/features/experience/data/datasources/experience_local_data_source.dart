import '../../domain/entities/experience_entity.dart';

abstract class ExperienceLocalDataSource {
  Future<List<Experience>> getExperiences();
}

class ExperienceLocalDataSourceImpl implements ExperienceLocalDataSource {
  @override
  Future<List<Experience>> getExperiences() async {
    return _experiences;
  }

  static const List<Experience> _experiences = [
    Experience(
      company: 'The First-Agency',
      role: 'Flutter Developer',
      period: '2025 – now',
      achievements: [
        'Led the design and implementation of Tolet Mobile App',
        'Added maintenance in the High-gold Mobile App',
      ],
    ),
    Experience(
      company: 'Gomla',
      role: 'Flutter Developer (Part-time)',
      period: '2024 – 2025',
      achievements: [
        'Enhanced the design and redesigned screens in Gomla-Mobile App',
        'Reduced app load time by 25% through performance optimization using RiverPod',
      ],
    ),
    Experience(
      company: 'Stock Tech',
      role: 'Flutter Developer',
      period: '2024 – 2025',
      achievements: [
        'Led the design and implementation of Palleta Mobile App',
        'Led design and maintenance of Stock App (B2B), achieving 10,000+ downloads and 4.8-star rating',
        'Delivered Tag-pharma & DrugZa Mobile App with 35% increase in customer engagement',
        'Reduced app load time by 20% through performance optimization using Bloc',
      ],
    ),
    Experience(
      company: 'Freelance (Many Companies)',
      role: 'Flutter Developer',
      period: '2023 - 2024',
      achievements: [
        'Developed and deployed 10+ cross-platform mobile applications',
        'Optimized app performance by 30% through debugging and code refactoring',
        'Improved user engagement by 35% through intuitive UI/UX design',
      ],
    ),
    Experience(
      company: 'Innovation Company',
      role: 'Flutter Developer',
      period: '2022 – 2023',
      achievements: [
        'Led design and implementation of Al-Taqwa Mobile App (1,000+ downloads, 4.8-star rating)',
        'Delivered Global Dent Mobile App with 35% increase in customer engagement',
        'Reduced app load time by 20% through performance optimization',
      ],
    ),
  ];
}
