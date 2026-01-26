import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/hero_repository.dart';
import 'hero_state.dart';

class HeroCubit extends Cubit<HeroState> {
  final HeroRepository repository;

  HeroCubit(this.repository) : super(HeroInitial());

  Future<void> loadHeroData() async {
    emit(HeroLoading());
    try {
      final heroData = await repository.getHeroData();
      emit(HeroLoaded(heroData));
    } catch (e) {
      emit(const HeroError('Failed to load hero data'));
    }
  }
}
