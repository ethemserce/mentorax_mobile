import 'package:go_router/go_router.dart';
import 'package:mentorax/features/materials/data/models/material_chunk_model.dart';
import 'package:mentorax/features/materials/data/models/material_model.dart';
import 'package:mentorax/features/materials/presentation/pages/create_material_chunk_page.dart';
import 'package:mentorax/features/materials/presentation/pages/edit_material_chunk_page.dart';
import 'package:mentorax/features/materials/presentation/pages/material_chunk_detail_page.dart';
import 'package:mentorax/features/materials/presentation/pages/material_chunks_page.dart';
import 'package:mentorax/features/materials/presentation/pages/material_detail_page.dart';
import 'package:mentorax/features/progress/presentation/pages/progress_page.dart';
import 'package:mentorax/features/settings/presentation/pages/notification_test_page.dart';
import 'package:mentorax/features/settings/presentation/pages/reminder_debug_page.dart';
import 'package:mentorax/features/study_plans/presentation/pages/plan_detail_page.dart';
import 'package:mentorax/features/study_plans/presentation/pages/plan_list_page.dart';
import 'package:mentorax/features/study_sessions/presentation/pages/session_running_page.dart';
import 'package:mentorax/features/study_sessions/presentation/pages/session_success_page.dart';
import 'package:mentorax/features/study_sessions/presentation/pages/study_room_page.dart';
import '../../app/root_shell_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/data/models/next_session_model.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/materials/presentation/pages/create_material_page.dart';
import '../../features/materials/presentation/pages/material_list_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/study_plans/presentation/pages/create_plan_page.dart';
import '../../features/study_sessions/presentation/pages/complete_session_page.dart';
import '../../features/study_sessions/presentation/pages/next_session_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => RootShellPage(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/materials',
            name: 'materials',
            builder: (context, state) => const MaterialListPage(),
          ),
          GoRoute(
            path: '/progress',
            name: 'progress',
            builder: (context, state) => const ProgressPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/materials/create',
        name: 'create-material',
        builder: (context, state) => const CreateMaterialPage(),
      ),
GoRoute(
  path: '/materials/detail',
  builder: (context, state) {
    final extra = state.extra;

    if (extra is String) {
      return MaterialDetailPage(materialId: extra);
    }

    if (extra is MaterialModel) {
      return MaterialDetailPage(materialId: extra.id);
    }

    throw Exception('MaterialDetailPage requires materialId');
  },
),
GoRoute(
  path: '/session-running',
  name: 'session-running',
  builder: (context, state) {
    final session = state.extra as NextSessionModel;
    return SessionRunningPage(session: session);
  },
),
      GoRoute(
        path: '/plans/create',
        name: 'create-plan',
        builder: (context, state) {
          final materialId = state.extra as String;
          return CreatePlanPage(materialId: materialId);
        },
      ),
      GoRoute(
        path: '/next-session',
        name: 'next-session',
        builder: (context, state) => const NextSessionPage(),
      ),
      GoRoute(
  path: '/settings/notification-test',
  name: 'notification-test',
  builder: (context, state) => const NotificationTestPage(),
),
      GoRoute(
  path: '/session-success',
  builder: (context, state) {
    final data = state.extra as Map<String, dynamic>;
    return SessionSuccessPage(
      durationMinutes: data['durationMinutes'] as int,
      qualityScore: data['qualityScore'] as int,
      streakDays: data['streakDays'] as int,
    );
  },
),
      GoRoute(
  path: '/plans/detail',
  name: 'plan-detail',
  builder: (context, state) {
    final planId = state.extra as String;
    return PlanDetailPage(planId: planId);
  },
),
     GoRoute(
  path: '/plans',
  name: 'plans',
  builder: (context, state) {
    final materialId = state.extra as String?;
    return PlanListPage(materialId: materialId);
  },
),
GoRoute(
  path: '/settings/reminder-debug',
  name: 'reminder-debug',
  builder: (context, state) => const ReminderDebugPage(),
),
GoRoute(
  path: '/materials/chunks',
  name: 'material-chunks',
  builder: (context, state) {
    final materialId = state.extra as String;
    return MaterialChunksPage(materialId: materialId);
  },
),
GoRoute(
  path: '/materials/chunks/detail',
  name: 'material-chunk-detail',
  builder: (context, state) {
    final chunk = state.extra as MaterialChunkModel;
    return MaterialChunkDetailPage(chunk: chunk);
  },
),
GoRoute(
  path: '/materials/chunks/edit',
  name: 'material-chunk-edit',
  builder: (context, state) {
    final chunk = state.extra as MaterialChunkModel;
    return EditMaterialChunkPage(chunk: chunk);
  },
),
GoRoute(
  path: '/materials/chunks/create',
  name: 'material-chunk-create',
  builder: (context, state) {
    final materialId = state.extra as String;
    return CreateMaterialChunkPage(materialId: materialId);
  },
),
GoRoute(
  path: '/session-complete',
  name: 'session-complete',
  builder: (context, state) {
    final extra = state.extra;

    if (extra is NextSessionModel) {
      return CompleteSessionPage(session: extra);
    }

    if (extra is Map<String, dynamic>) {
      return CompleteSessionPage(
        session: extra['session'] as NextSessionModel,
        initialNotes: extra['notes'] as String?,
        elapsedSeconds: extra['elapsedSeconds'] as int?,
      );
    }

    throw Exception('CompleteSessionPage requires NextSessionModel');
  },
),
GoRoute(
  path: '/study-room',
  name: 'study-room',
  builder: (context, state) {
    final extra = state.extra;

    late final String sessionId;

    if (extra is String) {
      sessionId = extra;
    } else if (extra is NextSessionModel) {
      sessionId = extra.sessionId;
    } else {
      throw Exception('StudyRoom requires a sessionId');
    }

    return StudyRoomPage(sessionId: sessionId);
  },
),
    ],
  );
}