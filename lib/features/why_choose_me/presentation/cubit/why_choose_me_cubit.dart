import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/why_choose_me_repository.dart';
import 'why_choose_me_state.dart';

class WhyChooseMeCubit extends Cubit<WhyChooseMeState> {
  final WhyChooseMeRepository repository;

  WhyChooseMeCubit({required this.repository}) : super(WhyChooseMeInitial());

  Future<void> loadReasons() async {
    try {
      emit(WhyChooseMeLoading());
      final reasons = await repository.getReasons();
      emit(WhyChooseMeLoaded(reasons));
    } catch (e) {
      emit(WhyChooseMeError(e.toString()));
    }
  }
}
