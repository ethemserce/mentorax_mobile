import 'dashboard_service.dart';
import 'models/mobile_dashboard_model.dart';
import 'models/next_session_model.dart';

class DashboardRepository {
  final DashboardService _service;

  DashboardRepository(this._service);

  Future<MobileDashboardModel> getDashboard() {
    return _service.getDashboard();
  }

  Future<NextSessionModel> getNextSession() {
    return _service.getNextSession();
  }

  Future<NextSessionModel> startSession(String sessionId) {
    return _service.startSession(sessionId);
  }

  Future<void> completeSession({
    required String sessionId,
    required int qualityScore,
    required int difficultyScore,
    required int actualDurationMinutes,
    required String? reviewNotes,
  }) {
    return _service.completeSession(
      sessionId: sessionId,
      qualityScore: qualityScore,
      difficultyScore: difficultyScore,
      actualDurationMinutes: actualDurationMinutes,
      reviewNotes: reviewNotes,
    );
  }
}