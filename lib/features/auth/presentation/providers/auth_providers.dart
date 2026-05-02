import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/auth/local_session_resetter.dart';
import 'package:mentorax/core/database/database_provider.dart';
import 'package:mentorax/core/sync/sync_providers.dart';
import 'package:mentorax/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:mentorax/features/materials/presentation/providers/material_providers.dart';
import 'package:mentorax/features/progress/presentation/providers/progress_providers.dart';
import 'package:mentorax/features/study_plans/presentation/providers/study_plan_providers.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/study_session_providers.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_service.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authServiceProvider),
    ref.read(tokenStorageProvider),
  );
});

final localSessionResetterProvider = Provider<LocalSessionResetter>((ref) {
  return LocalSessionResetter(
    database: ref.read(appDatabaseProvider),
    syncStateStorage: ref.read(syncStateStorageProvider),
  );
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(
      ref.read(tokenStorageProvider),
      onSessionEnded: () => _clearLocalSessionBoundary(ref),
    );
  },
);

Future<void> _clearLocalSessionBoundary(Ref ref) async {
  await ref.read(localSessionResetterProvider).clear();

  ref.invalidate(syncStatusProvider);
  ref.invalidate(dashboardProvider);
  ref.invalidate(nextSessionProvider);
  ref.invalidate(materialListProvider);
  ref.invalidate(materialDetailProvider);
  ref.invalidate(materialChunksProvider);
  ref.invalidate(studyPlansProvider);
  ref.invalidate(studyPlanDetailProvider);
  ref.invalidate(progressSummaryProvider);
  ref.invalidate(studySessionDetailProvider);
}
