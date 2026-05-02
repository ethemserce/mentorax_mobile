import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/database/database_provider.dart';
import 'package:mentorax/features/progress/data/models/mobile_progress_summary_model.dart';
import 'package:mentorax/features/progress/data/progress_local_data_source.dart';
import 'package:mentorax/features/progress/data/progress_repository.dart';
import 'package:mentorax/features/progress/data/progress_service.dart';

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

final progressLocalDataSourceProvider = Provider<ProgressLocalDataSource>((
  ref,
) {
  return ProgressLocalDataSource(ref.read(appDatabaseProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(
    service: ref.read(progressServiceProvider),
    local: ref.read(progressLocalDataSourceProvider),
  );
});

final progressSummaryProvider = FutureProvider<MobileProgressSummaryModel>((
  ref,
) async {
  return ref.read(progressRepositoryProvider).getSummary();
});
