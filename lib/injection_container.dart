import 'package:get_it/get_it.dart';
import 'features/projects/data/datasources/project_local_data_source.dart';
import 'features/projects/data/repositories/project_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/presentation/cubit/projects_cubit.dart';
import 'features/experience/data/datasources/experience_local_data_source.dart';
import 'features/experience/data/repositories/experience_repository_impl.dart';
import 'features/experience/domain/repositories/experience_repository.dart';
import 'features/experience/presentation/cubit/experience_cubit.dart';
import 'features/expertise/data/datasources/expertise_local_data_source.dart';
import 'features/expertise/data/repositories/expertise_repository_impl.dart';
import 'features/expertise/domain/repositories/expertise_repository.dart';
import 'features/expertise/presentation/cubit/expertise_cubit.dart';
import 'features/hero/data/datasources/hero_local_data_source.dart';
import 'features/hero/data/repositories/hero_repository_impl.dart';
import 'features/hero/domain/repositories/hero_repository.dart';
import 'features/hero/presentation/cubit/hero_cubit.dart';
import 'features/about/data/datasources/about_local_data_source.dart';
import 'features/about/data/repositories/about_repository_impl.dart';
import 'features/about/domain/repositories/about_repository.dart';
import 'features/about/presentation/cubit/about_cubit.dart';
import 'features/contact/data/datasources/contact_local_data_source.dart';
import 'features/contact/data/repositories/contact_repository_impl.dart';
import 'features/contact/domain/repositories/contact_repository.dart';
import 'features/contact/presentation/cubit/contact_cubit.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  // Features - Projects
  // Bloc
  sl.registerFactory(() => ProjectsCubit(sl()));

  // Repository
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProjectLocalDataSource>(
    () => ProjectLocalDataSourceImpl(),
  );

  // Features - Experience
  // Bloc
  sl.registerFactory(() => ExperienceCubit(sl()));

  // Repository
  sl.registerLazySingleton<ExperienceRepository>(
    () => ExperienceRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ExperienceLocalDataSource>(
    () => ExperienceLocalDataSourceImpl(),
  );

  // Features - Expertise
  // Bloc
  sl.registerFactory(() => ExpertiseCubit(sl()));

  // Repository
  sl.registerLazySingleton<ExpertiseRepository>(
    () => ExpertiseRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ExpertiseLocalDataSource>(
    () => ExpertiseLocalDataSourceImpl(),
  );

  // Features - Hero
  // Bloc
  sl.registerFactory(() => HeroCubit(sl()));

  // Repository
  sl.registerLazySingleton<HeroRepository>(
    () => HeroRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<HeroLocalDataSource>(
    () => HeroLocalDataSourceImpl(),
  );

  // Features - About
  // Bloc
  sl.registerFactory(() => AboutCubit(sl()));

  // Repository
  sl.registerLazySingleton<AboutRepository>(
    () => AboutRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AboutLocalDataSource>(
    () => AboutLocalDataSourceImpl(),
  );

  // Features - Contact
  // Bloc
  sl.registerFactory(() => ContactCubit(sl()));

  // Repository
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ContactLocalDataSource>(
    () => ContactLocalDataSourceImpl(),
  );
}
