import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/about_repository.dart';
import 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  final AboutRepository repository;

  AboutCubit(this.repository) : super(AboutInitial());

  Future<void> loadAboutData() async {
    emit(AboutLoading());
    try {
      final aboutData = await repository.getAboutData();
      emit(AboutLoaded(aboutData));
    } catch (e) {
      emit(const AboutError('Failed to load about data'));
    }
  }
}
