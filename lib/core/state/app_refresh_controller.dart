import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/dashboard/presentation/providers/dashboard_providers.dart';
import '../../features/materials/presentation/providers/material_providers.dart';
import '../../features/progress/presentation/providers/progress_providers.dart';
import '../../features/study_plans/presentation/providers/study_plan_providers.dart';
import '../../features/study_sessions/presentation/providers/study_session_providers.dart';

final appRefreshControllerProvider = Provider((ref) {
  return AppRefreshController(ref);
});

class AppRefreshController {
  final Ref _ref;

  AppRefreshController(this._ref);

  void refreshDashboard() {
    _ref.invalidate(dashboardProvider);
  }

  void refreshMaterials() {
    _ref.invalidate(materialListProvider);
  }

  void refreshMaterialDetail(String materialId) {
    _ref.invalidate(materialDetailProvider(materialId));
  }

  void refreshProgress() {
    _ref.invalidate(progressSummaryProvider);
  }

  void refreshNextSession() {
    _ref.invalidate(nextSessionProvider);
  }

  void refreshStudyPlans() {
    _ref.invalidate(studyPlansProvider);
  }

  void refreshStudyPlanDetail(String planId) {
    _ref.invalidate(studyPlanDetailProvider(planId));
  }

  void refreshStudyFlow() {
    refreshDashboard();
    refreshProgress();
    refreshNextSession();
    refreshStudyPlans();
  }

  void refreshAfterMaterialCreated() {
    refreshMaterials();
    refreshDashboard();
  }

  void refreshAfterMaterialChanged({
    String? materialId,
  }) {
    refreshMaterials();
    refreshDashboard();

    if (materialId != null) {
      refreshMaterialDetail(materialId);
      _ref.invalidate(materialChunksProvider(materialId));
    }
  }

  void refreshAfterPlanCreated({
    String? materialId,
    String? planId,
  }) {
    refreshMaterials();
    refreshDashboard();
    refreshNextSession();
    refreshProgress();
    refreshStudyPlans();

    if (materialId != null) {
      refreshMaterialDetail(materialId);
      _ref.invalidate(materialChunksProvider(materialId));
    }

    if (planId != null) {
      refreshStudyPlanDetail(planId);
    }
  }

  void refreshAfterPlanChanged({
    String? materialId,
    String? planId,
  }) {
    refreshMaterials();
    refreshDashboard();
    refreshNextSession();
    refreshProgress();
    refreshStudyPlans();

    if (materialId != null) {
      refreshMaterialDetail(materialId);
    }

    if (planId != null) {
      refreshStudyPlanDetail(planId);
    }
  }

  void refreshAfterSessionStarted({
    String? materialId,
    String? planId,
  }) {
    refreshDashboard();
    refreshNextSession();
    refreshStudyPlans();

    if (materialId != null) {
      refreshMaterialDetail(materialId);
    }

    if (planId != null) {
      refreshStudyPlanDetail(planId);
    }
  }

  void refreshAfterSessionCompleted({
    String? materialId,
    String? planId,
  }) {
    refreshDashboard();
    refreshProgress();
    refreshNextSession();
    refreshStudyPlans();
    refreshMaterials();

    if (materialId != null) {
      refreshMaterialDetail(materialId);
    }

    if (planId != null) {
      refreshStudyPlanDetail(planId);
    }
  }

  void refreshAfterChunkChanged(String materialId) {
    refreshMaterials();
    refreshMaterialDetail(materialId);
    _ref.invalidate(materialChunksProvider(materialId));
  }
}