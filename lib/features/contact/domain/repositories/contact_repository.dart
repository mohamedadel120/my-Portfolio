import '../entities/contact_entity.dart';

abstract class ContactRepository {
  Future<ContactData> getContactData();
}
