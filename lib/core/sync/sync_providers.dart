import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/database/database_provider.dart';

import 'sync_repository.dart';
import 'sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(
    database: ref.read(appDatabaseProvider),
    service: ref.read(syncServiceProvider),
  );
});
