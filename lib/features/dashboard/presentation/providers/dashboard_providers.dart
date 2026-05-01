import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/database/database_provider.dart';
import 'package:mentorax/core/sync/sync_providers.dart';
import '../../data/dashboard_local_data_source.dart';
import '../../data/dashboard_repository.dart';
import '../../data/dashboard_service.dart';
import '../../data/models/mobile_dashboard_model.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final dashboardLocalDataSourceProvider = Provider<DashboardLocalDataSource>((
  ref,
) {
  return DashboardLocalDataSource(ref.read(appDatabaseProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    service: ref.read(dashboardServiceProvider),
    local: ref.read(dashboardLocalDataSourceProvider),
    sync: ref.read(syncRepositoryProvider),
  );
});

final dashboardProvider = FutureProvider<MobileDashboardModel>((ref) async {
  return ref.read(dashboardRepositoryProvider).getDashboard();
});
