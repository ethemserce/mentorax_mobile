import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('stores local materials and pending sync operations', () async {
    await database
        .into(database.localMaterials)
        .insert(
          LocalMaterialsCompanion.insert(
            id: 'material-1',
            userId: 'user-1',
            title: 'Offline Study Material',
            materialType: 'Text',
            content: 'Chunkable content',
            estimatedDurationMinutes: 25,
          ),
        );

    await database
        .into(database.syncOutbox)
        .insert(
          SyncOutboxCompanion.insert(
            id: 'operation-1',
            operationType: 'StudySessionCompleted',
            entityType: 'StudySession',
            entityId: 'session-1',
            payload: '{"sessionId":"session-1"}',
            createdAtUtc: DateTime.utc(2026, 5),
          ),
        );

    final materials = await database.select(database.localMaterials).get();
    final operations = await database.select(database.syncOutbox).get();

    expect(materials, hasLength(1));
    expect(materials.single.title, 'Offline Study Material');
    expect(operations, hasLength(1));
    expect(operations.single.status, 'pending');
  });
}
