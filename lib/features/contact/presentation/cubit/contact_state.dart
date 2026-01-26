import 'package:equatable/equatable.dart';
import '../../domain/entities/contact_entity.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final ContactData contactData;

  const ContactLoaded(this.contactData);

  @override
  List<Object> get props => [contactData];
}

class ContactError extends ContactState {
  final String message;

  const ContactError(this.message);

  @override
  List<Object> get props => [message];
}
