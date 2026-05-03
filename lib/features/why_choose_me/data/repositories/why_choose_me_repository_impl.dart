import '../../../../models/why_choose_me_reason.dart';
import '../../domain/repositories/why_choose_me_repository.dart';
import '../datasources/why_choose_me_remote_data_source.dart';

class WhyChooseMeRepositoryImpl implements WhyChooseMeRepository {
  final WhyChooseMeRemoteDataSource remoteDataSource;

  WhyChooseMeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WhyChooseMeReason>> getReasons() async {
    return await remoteDataSource.getReasons();
  }
}
