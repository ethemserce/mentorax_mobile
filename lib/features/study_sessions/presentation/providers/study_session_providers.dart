import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/features/study_sessions/data/models/study_session_detail_model.dart';
import 'package:mentorax/features/study_sessions/data/study_session_service.dart';
import '../../../dashboard/data/dashboard_repository.dart';
import '../../../dashboard/data/dashboard_service.dart';
import '../../../dashboard/data/models/next_session_model.dart';

final sessionDashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final sessionDashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.read(sessionDashboardServiceProvider));
});

final nextSessionProvider = FutureProvider<NextSessionModel>((ref) async {
  return ref.read(sessionDashboardRepositoryProvider).getNextSession();
});

final studySessionServiceProvider = Provider<StudySessionService>((ref) {
  return StudySessionService();
});

final studySessionDetailProvider =
    FutureProvider.family<StudySessionDetailModel, String>((ref, sessionId) {
  return ref.read(studySessionServiceProvider).getSessionById(sessionId);
});