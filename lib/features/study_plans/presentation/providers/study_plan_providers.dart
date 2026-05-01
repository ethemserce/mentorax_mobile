import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/database/database_provider.dart';
import '../../data/models/study_plan_model.dart';
import '../../data/study_plan_local_data_source.dart';
import '../../data/study_plan_repository.dart';
import '../../data/study_plan_service.dart';
import '../../data/models/study_plan_detail_model.dart';

final studyPlanServiceProvider = Provider<StudyPlanService>((ref) {
  return StudyPlanService();
});

final studyPlanLocalDataSourceProvider = Provider<StudyPlanLocalDataSource>((
  ref,
) {
  return StudyPlanLocalDataSource(ref.read(appDatabaseProvider));
});

final studyPlanRepositoryProvider = Provider<StudyPlanRepository>((ref) {
  return StudyPlanRepository(
    remote: ref.read(studyPlanServiceProvider),
    local: ref.read(studyPlanLocalDataSourceProvider),
  );
});

final studyPlansProvider = FutureProvider<List<StudyPlanModel>>((ref) async {
  return ref.read(studyPlanRepositoryProvider).getPlans();
});

final studyPlanDetailProvider =
    FutureProvider.family<StudyPlanDetailModel, String>((ref, planId) async {
      return ref.read(studyPlanRepositoryProvider).getPlanById(planId);
    });
