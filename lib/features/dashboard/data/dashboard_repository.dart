import 'package:mentorax/core/sync/sync_repository.dart';

import 'dashboard_local_data_source.dart';
import 'dashboard_service.dart';
import 'models/mobile_dashboard_model.dart';
import 'models/next_session_model.dart';

class DashboardRepository {
  final DashboardService _service;
  final DashboardLocalDataSource _local;
  final SyncRepository? _sync;

  DashboardRepository({
    required DashboardService service,
    required DashboardLocalDataSource local,
    SyncRepository? sync,
  }) : _service = service,
       _local = local,
       _sync = sync;

  Future<MobileDashboardModel> getDashboard() async {
    try {
      await _pushPendingSyncOperations();
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
      await _pushPendingSyncOperations();
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
    final localStarted = await _local.markSessionStartedLocally(sessionId);

    if (localStarted != null) {
      try {
        final remoteStarted = await _service.startSession(sessionId);
        await _local.cacheNextSession(remoteStarted);
        await _local.markSessionStartSynced(sessionId);

        return remoteStarted;
      } catch (_) {
        return localStarted;
      }
    }

    final remoteStarted = await _service.startSession(sessionId);
    await _local.cacheNextSession(remoteStarted);

    return remoteStarted;
  }

  Future<void> completeSession({
    required String sessionId,
    required int qualityScore,
    required int difficultyScore,
    required int actualDurationMinutes,
    required String? reviewNotes,
  }) async {
    final completedLocally = await _local.markSessionCompletedLocally(
      sessionId: sessionId,
      qualityScore: qualityScore,
      difficultyScore: difficultyScore,
      actualDurationMinutes: actualDurationMinutes,
      reviewNotes: reviewNotes,
    );

    if (completedLocally) {
      try {
        await _service.completeSession(
          sessionId: sessionId,
          qualityScore: qualityScore,
          difficultyScore: difficultyScore,
          actualDurationMinutes: actualDurationMinutes,
          reviewNotes: reviewNotes,
        );
        await _local.markSessionCompleteSynced(sessionId);
      } catch (_) {
        return;
      }

      return;
    }

    await _service.completeSession(
      sessionId: sessionId,
      qualityScore: qualityScore,
      difficultyScore: difficultyScore,
      actualDurationMinutes: actualDurationMinutes,
      reviewNotes: reviewNotes,
    );
  }

  Future<void> _pushPendingSyncOperations() async {
    try {
      await _sync?.synchronize();
    } catch (_) {
      // Sync should never block local-first dashboard/session reads.
    }
  }
}
