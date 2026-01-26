import '../../domain/entities/contact_entity.dart';
import '../../../../core/constants/app_data.dart';

abstract class ContactLocalDataSource {
  Future<ContactData> getContactData();
}

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  @override
  Future<ContactData> getContactData() async {
    return const ContactData(
      title: 'Get In Touch',
      subtitle: 'Let\'s build something amazing together!',
      email: AppData.email,
      phone: AppData.phone,
      location: AppData.location,
      socialLinks: [
        SocialLink(
          name: 'Email',
          url: 'mailto:${AppData.email}',
          iconCode: 'email',
        ),
        SocialLink(
          name: 'GitHub',
          url: 'https://github.com/mohamedadel120',
          iconCode: 'code',
        ),
        SocialLink(
          name: 'LinkedIn',
          url: 'https://www.linkedin.com/in/mohamed-adel-9454a1183/',
          iconCode: 'link',
        ),
      ],
    );
  }
}
