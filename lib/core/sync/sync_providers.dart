import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/database/database_provider.dart';
import 'package:mentorax/features/dashboard/data/dashboard_local_data_source.dart';
import 'package:mentorax/features/study_plans/data/study_plan_local_data_source.dart';

import 'sync_repository.dart';
import 'sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final database = ref.read(appDatabaseProvider);

  return SyncRepository(
    database: database,
    service: ref.read(syncServiceProvider),
    studyPlanLocal: StudyPlanLocalDataSource(database),
    dashboardLocal: DashboardLocalDataSource(database),
  );
});
