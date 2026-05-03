import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/contact_entity.dart';

abstract class ContactRemoteDataSource {
  Future<ContactData> getContactData();
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final FirebaseFirestore firestore;

  ContactRemoteDataSourceImpl({required this.firestore});

  @override
  Future<ContactData> getContactData() async {
    try {
      debugPrint('Fetching Contact Data from FIREBASE...');
      final doc = await firestore.collection('profile_info').doc('main').get();
      if (!doc.exists) {
        throw Exception('Profile info not found');
      }
      final data = doc.data()!;
      debugPrint('Fetched Contact Data from FIREBASE successfully!');
      
      final email = data['email'] ?? '';
      
      return ContactData(
        title: 'Get In Touch',
        subtitle: 'Let\'s build something amazing together!',
        email: email,
        phone: data['phone'] ?? '',
        location: data['location'] ?? '',
        socialLinks: [
          SocialLink(
            name: 'Email',
            url: 'mailto:$email',
            iconCode: 'email',
          ),
          const SocialLink(
            name: 'GitHub',
            url: 'https://github.com/mohamedadel120',
            iconCode: 'code',
          ),
          const SocialLink(
            name: 'LinkedIn',
            url: 'https://www.linkedin.com/in/mohamed-adel-9454a1183/',
            iconCode: 'link',
          ),
        ],
      );
    } catch (e) {
      debugPrint('Failed to load contact data from Firebase: $e');
      throw Exception('Failed to load contact data from Firebase: $e');
    }
  }
}
