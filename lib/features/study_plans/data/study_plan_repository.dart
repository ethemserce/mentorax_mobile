import 'models/create_study_plan_request.dart';
import 'models/study_plan_detail_model.dart';
import 'models/study_plan_model.dart';
import 'study_plan_local_data_source.dart';
import 'study_plan_service.dart';

class StudyPlanRepository {
  final StudyPlanService _remote;
  final StudyPlanLocalDataSource _local;

  StudyPlanRepository({
    required StudyPlanService remote,
    required StudyPlanLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  Future<StudyPlanModel> createPlan(CreateStudyPlanRequest request) async {
    final plan = await _remote.createPlan(request);
    await _local.cachePlans([plan]);

    return plan;
  }

  Future<List<StudyPlanModel>> getPlans() async {
    try {
      final plans = await _remote.getPlans();
      await _local.cachePlans(plans);

      return plans;
    } catch (error) {
      final cached = await _local.getPlans();
      if (cached.isNotEmpty) return cached;

      rethrow;
    }
  }

  Future<StudyPlanDetailModel> getPlanById(String planId) async {
    try {
      final plan = await _remote.getPlanById(planId);
      await _local.cachePlanDetail(plan);

      return plan;
    } catch (error) {
      final cached = await _local.getPlanById(planId);
      if (cached != null) return cached;

      rethrow;
    }
  }

  Future<void> pausePlan(String id) => _remote.pausePlan(id);

  Future<void> resumePlan(String id) => _remote.resumePlan(id);

  Future<void> cancelPlan(String id) => _remote.cancelPlan(id);

  Future<void> completePlan(String id) => _remote.completePlan(id);
}
