import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/study_plan_model.dart';
import '../../data/study_plan_service.dart';
import '../../data/models/study_plan_detail_model.dart';

final studyPlanServiceProvider = Provider<StudyPlanService>((ref) {
  return StudyPlanService();
});

final studyPlansProvider = FutureProvider<List<StudyPlanModel>>((ref) async {
  return ref.read(studyPlanServiceProvider).getPlans();
});

final studyPlanDetailProvider =
    FutureProvider.family<StudyPlanDetailModel, String>((ref, planId) async {
  return ref.read(studyPlanServiceProvider).getPlanById(planId);
});