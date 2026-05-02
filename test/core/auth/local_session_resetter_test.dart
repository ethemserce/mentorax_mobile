import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/auth/local_session_resetter.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/core/sync/sync_state_storage.dart';

void main() {
  late AppDatabase database;
  late _FakeSyncStateStorage syncStateStorage;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    syncStateStorage = _FakeSyncStateStorage(
      lastSyncAt: DateTime.utc(2026, 5, 1, 10),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('clears local offline data and sync cursor', () async {
    await _seedLocalSessionData(database);
    final resetter = LocalSessionResetter(
      database: database,
      syncStateStorage: syncStateStorage,
    );

    await resetter.clear();

    expect(await database.select(database.localMaterials).get(), isEmpty);
    expect(await database.select(database.localMaterialChunks).get(), isEmpty);
    expect(await database.select(database.localStudyPlans).get(), isEmpty);
    expect(await database.select(database.localStudyPlanItems).get(), isEmpty);
    expect(await database.select(database.localStudySessions).get(), isEmpty);
    expect(await database.select(database.syncOutbox).get(), isEmpty);
    expect(syncStateStorage.lastSyncAt, isNull);
  });
}

Future<void> _seedLocalSessionData(AppDatabase database) async {
  await database
      .into(database.localMaterials)
      .insert(
        LocalMaterialsCompanion.insert(
          id: 'material-1',
          userId: 'user-1',
          title: 'Cached Material',
          materialType: 'Text',
          content: 'Cached content',
          estimatedDurationMinutes: 30,
        ),
      );

  await database
      .into(database.localMaterialChunks)
      .insert(
        LocalMaterialChunksCompanion.insert(
          id: 'chunk-1',
          learningMaterialId: 'material-1',
          orderNo: 1,
          title: const Value('Cached Chunk'),
          content: 'Cached chunk',
          difficultyLevel: 2,
          estimatedStudyMinutes: 15,
          characterCount: 12,
        ),
      );

  await database
      .into(database.localStudyPlans)
      .insert(
        LocalStudyPlansCompanion.insert(
          id: 'plan-1',
          userId: 'user-1',
          learningMaterialId: 'material-1',
          title: 'Cached Plan',
          startDate: '2026-05-01',
          dailyTargetMinutes: 25,
          status: 'Active',
        ),
      );

  await database
      .into(database.localStudyPlanItems)
      .insert(
        LocalStudyPlanItemsCompanion.insert(
          id: 'item-1',
          studyPlanId: 'plan-1',
          materialChunkId: const Value('chunk-1'),
          title: 'Cached Item',
          itemType: 'Study',
          orderNo: 1,
          plannedDateUtc: DateTime.utc(2026, 5, 1, 9),
          durationMinutes: 25,
          status: 'Pending',
        ),
      );

  await database
      .into(database.localStudySessions)
      .insert(
        LocalStudySessionsCompanion.insert(
          id: 'session-1',
          studyPlanId: 'plan-1',
          studyPlanItemId: const Value('item-1'),
          learningMaterialId: 'material-1',
          scheduledAtUtc: DateTime.utc(2026, 5, 1, 9),
        ),
      );

  await database
      .into(database.syncOutbox)
      .insert(
        SyncOutboxCompanion.insert(
          id: 'operation-1',
          operationType: 'StudySessionStarted',
          entityType: 'StudySession',
          entityId: 'session-1',
          payload: '{}',
          createdAtUtc: DateTime.utc(2026, 5, 1, 9),
        ),
      );
}

class _FakeSyncStateStorage implements SyncStateStorage {
  DateTime? lastSyncAt;

  _FakeSyncStateStorage({this.lastSyncAt});

  @override
  Future<void> clearLastSyncAt() async {
    lastSyncAt = null;
  }

  @override
  Future<DateTime?> getLastSyncAt() async {
    return lastSyncAt;
  }

  @override
  Future<void> saveLastSyncAt(DateTime value) async {
    lastSyncAt = value.toUtc();
  }
}
