import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/features/study_sessions/data/models/study_session_detail_model.dart';
import 'package:mentorax/features/study_sessions/data/study_session_local_data_source.dart';
import 'package:mentorax/features/study_sessions/data/study_session_repository.dart';
import 'package:mentorax/features/study_sessions/data/study_session_service.dart';

void main() {
  late AppDatabase database;
  late StudySessionLocalDataSource local;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    local = StudySessionLocalDataSource(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'falls back to cached active session details when remote fails',
    () async {
      final startedAt = DateTime.now().toUtc().subtract(
        const Duration(minutes: 7),
      );
      final session = _detail(startedAt: startedAt);
      final repository = StudySessionRepository(
        remote: _FailingStudySessionService(),
        local: local,
      );

      await local.cacheSessionDetail(session);

      final cached = await repository.getSessionById(session.id);

      expect(cached.id, session.id);
      expect(
        cached.startedAtUtc!.toUtc().difference(startedAt).inSeconds.abs(),
        lessThan(1),
      );
      expect(cached.isCompleted, isFalse);
      expect(cached.materialTitle, 'Offline Material');
    },
  );
}

StudySessionDetailModel _detail({required DateTime startedAt}) {
  return StudySessionDetailModel(
    id: 'session-1',
    studyPlanId: 'plan-1',
    studyPlanItemId: 'item-1',
    learningMaterialId: 'material-1',
    materialChunkId: 'chunk-1',
    planTitle: 'Offline Plan',
    materialTitle: 'Offline Material',
    chunkTitle: 'Chunk 1',
    chunkContent: 'Study this offline content.',
    itemType: 'NewStudy',
    sequenceNumber: 1,
    scheduledAtUtc: startedAt.subtract(const Duration(minutes: 5)),
    startedAtUtc: startedAt,
    plannedDurationMinutes: 25,
    status: 'InProgress',
    completedAtUtc: null,
    actualDurationMinutes: null,
    notes: null,
  );
}

class _FailingStudySessionService extends StudySessionService {
  @override
  Future<StudySessionDetailModel> getSessionById(String sessionId) {
    throw Exception('network unavailable');
  }
}
