import 'dashboard_local_data_source.dart';
import 'dashboard_service.dart';
import 'models/mobile_dashboard_model.dart';
import 'models/next_session_model.dart';

class DashboardRepository {
  final DashboardService _service;
  final DashboardLocalDataSource _local;

  DashboardRepository({
    required DashboardService service,
    required DashboardLocalDataSource local,
  }) : _service = service,
       _local = local;

  Future<MobileDashboardModel> getDashboard() async {
    try {
      final dashboard = await _service.getDashboard();
      final nextSession = dashboard.nextSession;

      if (nextSession != null) {
        await _local.cacheNextSession(nextSession);
      }

      return dashboard;
    } catch (error) {
      final cached = await _local.getDashboard();
      if (cached != null) return cached;

      rethrow;
    }
  }

  Future<NextSessionModel> getNextSession() async {
    try {
      final session = await _service.getNextSession();
      await _local.cacheNextSession(session);

      return session;
    } catch (error) {
      final cached = await _local.getNextSession();
      if (cached != null) return cached;

      rethrow;
    }
  }

  Future<NextSessionModel> startSession(String sessionId) async {
    final session = await _service.startSession(sessionId);
    await _local.cacheNextSession(session);

    return session;
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
