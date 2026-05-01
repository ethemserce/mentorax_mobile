import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/database/database_provider.dart';
import 'package:mentorax/features/dashboard/data/dashboard_local_data_source.dart';
import 'package:mentorax/features/study_plans/data/study_plan_local_data_source.dart';

import 'sync_repository.dart';
import 'sync_service.dart';
import 'sync_state_storage.dart';
import 'sync_status_model.dart';
import 'sync_status_repository.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final syncStateStorageProvider = Provider<SyncStateStorage>((ref) {
  return SecureSyncStateStorage();
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final database = ref.read(appDatabaseProvider);

  return SyncRepository(
    database: database,
    service: ref.read(syncServiceProvider),
    stateStorage: ref.read(syncStateStorageProvider),
    studyPlanLocal: StudyPlanLocalDataSource(database),
    dashboardLocal: DashboardLocalDataSource(database),
  );
});

final syncStatusRepositoryProvider = Provider<SyncStatusRepository>((ref) {
  return SyncStatusRepository(
    database: ref.read(appDatabaseProvider),
    stateStorage: ref.read(syncStateStorageProvider),
  );
});

final syncStatusProvider = FutureProvider<SyncStatusModel>((ref) {
  return ref.read(syncStatusRepositoryProvider).getStatus();
});
