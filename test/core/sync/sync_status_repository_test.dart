import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/core/sync/sync_state_storage.dart';
import 'package:mentorax/core/sync/sync_status_repository.dart';

void main() {
  late AppDatabase database;
  late _FakeSyncStateStorage storage;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    storage = _FakeSyncStateStorage(lastSyncAt: DateTime.utc(2026, 5, 1, 10));
  });

  tearDown(() async {
    await database.close();
  });

  test('summarizes pending, conflict, retry and last sync state', () async {
    final now = DateTime.now().toUtc();

    await database.batch((batch) {
      batch.insert(
        database.syncOutbox,
        SyncOutboxCompanion.insert(
          id: 'pending-now',
          operationType: 'StudySessionStarted',
          entityType: 'StudySession',
          entityId: 'session-1',
          payload: '{}',
          status: const Value('pending'),
          createdAtUtc: now.subtract(const Duration(minutes: 5)),
        ),
      );
      batch.insert(
        database.syncOutbox,
        SyncOutboxCompanion.insert(
          id: 'pending-later',
          operationType: 'StudySessionCompleted',
          entityType: 'StudySession',
          entityId: 'session-2',
          payload: '{}',
          status: const Value('pending'),
          retryCount: const Value(1),
          lastError: const Value('network unavailable'),
          createdAtUtc: now.subtract(const Duration(minutes: 4)),
          updatedAtUtc: Value(now.subtract(const Duration(minutes: 1))),
          nextAttemptAtUtc: Value(now.add(const Duration(minutes: 10))),
        ),
      );
      batch.insert(
        database.syncOutbox,
        SyncOutboxCompanion.insert(
          id: 'conflict',
          operationType: 'StudySessionCompleted',
          entityType: 'StudySession',
          entityId: 'session-3',
          payload: '{}',
          status: const Value('conflict'),
          lastError: const Value('study_plan_not_active'),
          createdAtUtc: now.subtract(const Duration(minutes: 3)),
          updatedAtUtc: Value(now),
        ),
      );
    });

    final repository = SyncStatusRepository(
      database: database,
      stateStorage: storage,
    );

    final status = await repository.getStatus();

    expect(status.lastSyncAt, DateTime.utc(2026, 5, 1, 10));
    expect(status.pendingCount, 2);
    expect(status.conflictCount, 1);
    expect(status.retryScheduledCount, 1);
    expect(status.lastError, 'study_plan_not_active');
    expect(status.hasPending, isTrue);
    expect(status.hasConflicts, isTrue);
    expect(status.isSynced, isFalse);
  });
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
