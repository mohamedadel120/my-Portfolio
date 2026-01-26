import '../../domain/entities/about_entity.dart';
import '../../../../core/constants/app_data.dart';

abstract class AboutLocalDataSource {
  Future<AboutData> getAboutData();
}

class AboutLocalDataSourceImpl implements AboutLocalDataSource {
  @override
  Future<AboutData> getAboutData() async {
    return const AboutData(
      title: 'About Me',
      professionalSummary: AppData.professionalSummary,
      downloadsCount: '10k+',
      ratings: '4.8',
      yearsExperience: '3+',
      features: [
        AboutFeature(
          title: 'Clean Code',
          description:
              'Writing maintainable, scalable, and well-documented code that teams love to work with.',
          iconCode: 'code_rounded',
        ),
        AboutFeature(
          title: 'Performance',
          description:
              'Optimizing for 60fps and lightning-fast load times. I make sure your users never wait.',
          iconCode: 'rocket_launch_rounded',
        ),
        AboutFeature(
          title: 'Architecture',
          description:
              'Robust Clean Architecture and MVVM patterns for enterprise-grade scalability.',
          iconCode: 'architecture_rounded',
        ),
        AboutFeature(
          title: 'Responsive',
          description:
              'Pixel-perfect experiences across all device categories, from mobile to desktop.',
          iconCode: 'devices_rounded',
        ),
      ],
      skills: [
        TechnicalSkill(
          name: 'Flutter & Dart',
          progress: 0.95,
          isPrimary: true,
        ),
        TechnicalSkill(
          name: 'Clean Architecture & Bloc',
          progress: 0.90,
          isPrimary: true,
        ),
        TechnicalSkill(
          name: 'Firebase & REST APIs',
          progress: 0.88,
          isPrimary: false,
        ),
      ],
    );
  }
}
