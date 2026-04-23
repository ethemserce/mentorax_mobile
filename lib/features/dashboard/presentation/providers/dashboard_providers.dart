import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dashboard_repository.dart';
import '../../data/dashboard_service.dart';
import '../../data/models/mobile_dashboard_model.dart';

final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.read(dashboardServiceProvider));
});

final dashboardProvider = FutureProvider<MobileDashboardModel>((ref) async {
  return ref.read(dashboardRepositoryProvider).getDashboard();
});