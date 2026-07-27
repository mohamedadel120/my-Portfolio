import 'firestore_rest.dart';

const _firestore = FirestoreRest('my-website-bf9e6');

class SocialLink {
  final String name;
  final String url;
  final String iconKey;

  const SocialLink({required this.name, required this.url, required this.iconKey});
}

class ContactData {
  final String email;
  final String phone;
  final String location;
  final List<SocialLink> socialLinks;

  const ContactData({
    required this.email,
    required this.phone,
    required this.location,
    required this.socialLinks,
  });
}

/// Ported from `ContactRemoteDataSource` — same `profile_info/main` document
/// as Hero/About, plus the two social links that are hardcoded in the
/// Flutter source itself (not Firestore fields).
Future<ContactData> fetchContactData() async {
  final data = await _firestore.getDocument('profile_info', 'main');
  final email = data['email'] as String? ?? '';

  return ContactData(
    email: email,
    phone: data['phone'] as String? ?? '',
    location: data['location'] as String? ?? '',
    socialLinks: [
      SocialLink(name: 'Email', url: 'mailto:$email', iconKey: 'email'),
      const SocialLink(name: 'GitHub', url: 'https://github.com/mohamedadel120', iconKey: 'code'),
      const SocialLink(
        name: 'LinkedIn',
        url: 'https://www.linkedin.com/in/mohamed-adel-9454a1183/',
        iconKey: 'link',
      ),
    ],
  );
}
