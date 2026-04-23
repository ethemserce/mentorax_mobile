import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/presentation/providers/dashboard_providers.dart';
import '../../features/materials/presentation/providers/material_providers.dart';
import '../../features/progress/presentation/providers/progress_providers.dart';
import '../../features/study_sessions/presentation/providers/study_session_providers.dart';

final appRefreshControllerProvider = Provider<AppRefreshController>((ref) {
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

  void refreshProgress() {
    _ref.invalidate(progressSummaryProvider);
  }

  void refreshNextSession() {
    _ref.invalidate(nextSessionProvider);
  }

  void refreshStudyFlow() {
    refreshDashboard();
    refreshProgress();
    refreshNextSession();
  }

  void refreshAfterMaterialCreated() {
    refreshMaterials();
    refreshDashboard();
  }

  void refreshAfterPlanCreated() {
    refreshMaterials();
    refreshDashboard();
    refreshNextSession();
    refreshProgress();
  }

  void refreshAfterSessionCompleted() {
    refreshDashboard();
    refreshProgress();
    refreshNextSession();
  }
}