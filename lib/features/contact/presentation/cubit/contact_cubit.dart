import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/contact_repository.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepository repository;

  ContactCubit(this.repository) : super(ContactInitial());

  Future<void> loadContactData() async {
    emit(ContactLoading());
    try {
      final contactData = await repository.getContactData();
      emit(ContactLoaded(contactData));
    } catch (e) {
      emit(const ContactError('Failed to load contact data'));
    }
  }
}
