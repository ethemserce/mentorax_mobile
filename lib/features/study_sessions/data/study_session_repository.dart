import 'models/study_session_detail_model.dart';
import 'study_session_local_data_source.dart';
import 'study_session_service.dart';

class StudySessionRepository {
  final StudySessionService _remote;
  final StudySessionLocalDataSource _local;

  StudySessionRepository({
    required StudySessionService remote,
    required StudySessionLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  Future<StudySessionDetailModel> getSessionById(String sessionId) async {
    try {
      final session = await _remote.getSessionById(sessionId);
      await _local.cacheSessionDetail(session);

      return session;
    } catch (error) {
      final cached = await _local.getSessionById(sessionId);
      if (cached != null) return cached;

      rethrow;
    }
  }
}
