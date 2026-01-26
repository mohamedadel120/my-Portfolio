import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_local_data_source.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDataSource localDataSource;

  ContactRepositoryImpl(this.localDataSource);

  @override
  Future<ContactData> getContactData() async {
    return await localDataSource.getContactData();
  }
}
