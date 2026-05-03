import '../../../../models/why_choose_me_reason.dart';

abstract class WhyChooseMeRepository {
  Future<List<WhyChooseMeReason>> getReasons();
}
