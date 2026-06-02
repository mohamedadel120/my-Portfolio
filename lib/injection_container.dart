import 'package:get_it/get_it.dart';
import 'features/projects/data/datasources/project_remote_data_source.dart';
import 'features/projects/data/repositories/project_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/presentation/cubit/projects_cubit.dart';
import 'features/experience/data/datasources/experience_remote_data_source.dart';
import 'features/experience/data/repositories/experience_repository_impl.dart';
import 'features/experience/domain/repositories/experience_repository.dart';
import 'features/experience/presentation/cubit/experience_cubit.dart';
import 'features/contact/data/datasources/contact_remote_data_source.dart';
import 'features/contact/data/repositories/contact_repository_impl.dart';
import 'features/contact/domain/repositories/contact_repository.dart';
import 'features/contact/presentation/cubit/contact_cubit.dart';
import 'features/hero/data/datasources/hero_remote_data_source.dart';
import 'features/hero/data/repositories/hero_repository_impl.dart';
import 'features/hero/domain/repositories/hero_repository.dart';
import 'features/hero/presentation/cubit/hero_cubit.dart';
import 'features/about/data/datasources/about_remote_data_source.dart';
import 'features/about/data/repositories/about_repository_impl.dart';
import 'features/about/domain/repositories/about_repository.dart';
import 'features/about/presentation/cubit/about_cubit.dart';
import 'features/expertise/data/datasources/expertise_remote_data_source.dart';
import 'features/expertise/data/repositories/expertise_repository_impl.dart';
import 'features/expertise/domain/repositories/expertise_repository.dart';
import 'features/expertise/presentation/cubit/expertise_cubit.dart';
import 'features/testimonials/data/datasources/testimonials_remote_data_source.dart';
import 'features/testimonials/data/repositories/testimonials_repository_impl.dart';
import 'features/testimonials/domain/repositories/testimonials_repository.dart';
import 'features/testimonials/presentation/cubit/testimonials_cubit.dart';
import 'features/why_choose_me/data/datasources/why_choose_me_remote_data_source.dart';
import 'features/why_choose_me/data/repositories/why_choose_me_repository_impl.dart';
import 'features/why_choose_me/domain/repositories/why_choose_me_repository.dart';
import 'features/why_choose_me/presentation/cubit/why_choose_me_cubit.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'core/services/analytics_service.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Core Services
  sl.registerLazySingleton(() => AnalyticsService());

  // Features - Projects
  // Bloc
  sl.registerLazySingleton(() => ProjectsCubit(sl()));

  // Repository
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Experience
  // Bloc
  sl.registerLazySingleton(() => ExperienceCubit(sl()));

  // Repository
  sl.registerLazySingleton<ExperienceRepository>(
    () => ExperienceRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ExperienceRemoteDataSource>(
    () => ExperienceRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Expertise
  // Bloc
  sl.registerLazySingleton(() => ExpertiseCubit(sl()));

  // Repository
  sl.registerLazySingleton<ExpertiseRepository>(
    () => ExpertiseRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ExpertiseRemoteDataSource>(
    () => ExpertiseRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Hero
  // Bloc
  sl.registerLazySingleton(() => HeroCubit(sl()));

  // Repository
  sl.registerLazySingleton<HeroRepository>(
    () => HeroRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<HeroRemoteDataSource>(
    () => HeroRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - About
  // Bloc
  sl.registerLazySingleton(() => AboutCubit(sl()));

  // Repository
  sl.registerLazySingleton<AboutRepository>(
    () => AboutRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AboutRemoteDataSource>(
    () => AboutRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Contact
  // Bloc
  sl.registerLazySingleton(() => ContactCubit(sl()));

  // Repository
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Testimonials
  // Bloc
  sl.registerLazySingleton(() => TestimonialsCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<TestimonialsRepository>(
    () => TestimonialsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TestimonialsRemoteDataSource>(
    () => TestimonialsRemoteDataSourceImpl(firestore: sl()),
  );

  // Features - Why Choose Me
  // Bloc
  sl.registerLazySingleton(() => WhyChooseMeCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<WhyChooseMeRepository>(
    () => WhyChooseMeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WhyChooseMeRemoteDataSource>(
    () => WhyChooseMeRemoteDataSourceImpl(firestore: sl()),
  );
}
