import 'package:mentorax/core/database/app_database.dart';
import 'package:mentorax/core/sync/sync_state_storage.dart';

class LocalSessionResetter {
  final AppDatabase _database;
  final SyncStateStorage _syncStateStorage;

  LocalSessionResetter({
    required AppDatabase database,
    required SyncStateStorage syncStateStorage,
  }) : _database = database,
       _syncStateStorage = syncStateStorage;

  Future<void> clear() async {
    await _database.transaction(() async {
      await _database.delete(_database.syncOutbox).go();
      await _database.delete(_database.localStudySessions).go();
      await _database.delete(_database.localStudyPlanItems).go();
      await _database.delete(_database.localStudyPlans).go();
      await _database.delete(_database.localMaterialChunks).go();
      await _database.delete(_database.localMaterials).go();
    });

    await _syncStateStorage.clearLastSyncAt();
  }
}
