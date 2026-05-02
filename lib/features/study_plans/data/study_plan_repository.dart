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

  Future<void> pausePlan(String id) {
    return _applyLifecycleOperation(
      applyLocal: () => _local.markPlanPausedLocally(id),
      applyRemote: () => _remote.pausePlan(id),
      markSynced: () => _local.markPlanPauseSynced(id),
    );
  }

  Future<void> resumePlan(String id) {
    return _applyLifecycleOperation(
      applyLocal: () => _local.markPlanResumedLocally(id),
      applyRemote: () => _remote.resumePlan(id),
      markSynced: () => _local.markPlanResumeSynced(id),
    );
  }

  Future<void> cancelPlan(String id) {
    return _applyLifecycleOperation(
      applyLocal: () => _local.markPlanCancelledLocally(id),
      applyRemote: () => _remote.cancelPlan(id),
      markSynced: () => _local.markPlanCancelSynced(id),
    );
  }

  Future<void> completePlan(String id) {
    return _applyLifecycleOperation(
      applyLocal: () => _local.markPlanCompletedLocally(id),
      applyRemote: () => _remote.completePlan(id),
      markSynced: () => _local.markPlanCompleteSynced(id),
    );
  }

  Future<void> _applyLifecycleOperation({
    required Future<bool> Function() applyLocal,
    required Future<void> Function() applyRemote,
    required Future<void> Function() markSynced,
  }) async {
    final appliedLocally = await applyLocal();

    if (appliedLocally) {
      try {
        await applyRemote();
        await markSynced();
      } catch (_) {
        return;
      }

      return;
    }

    await applyRemote();
  }
}
