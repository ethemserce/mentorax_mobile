import '../../features/dashboard/data/models/next_session_model.dart';
import '../../features/study_plans/data/models/study_plan_detail_model.dart';
import 'local_notification_service.dart';

class StudyReminderService {
  StudyReminderService._();

  static final StudyReminderService instance = StudyReminderService._();

  static const int _sessionReminderOffsetMinutes = 0;

  int _notificationIdFromString(String value) {
    return value.hashCode & 0x7fffffff;
  }

  int notificationIdForSession(String sessionId) {
    return _notificationIdFromString('session_$sessionId');
  }

  Future<void> scheduleForNextSession(NextSessionModel session) async {
    final scheduledAt = session.scheduledAtUtc.toLocal();
    final reminderAt =
        scheduledAt.subtract(const Duration(minutes: _sessionReminderOffsetMinutes));

    if (reminderAt.isBefore(DateTime.now())) {
      return;
    }

    await LocalNotificationService.instance.schedule(
      id: notificationIdForSession(session.sessionId),
      title: 'MentoraX Reminder',
      body:
          '${session.materialTitle} starts in $_sessionReminderOffsetMinutes minutes.',
      scheduledAt: reminderAt,
      payload: 'next_session:${session.sessionId}',
    );
  }

  Future<void> cancelForSession(String sessionId) async {
    await LocalNotificationService.instance
        .cancel(notificationIdForSession(sessionId));
  }

  Future<void> rescheduleFromPlanDetail(StudyPlanDetailModel plan) async {
    for (final session in plan.sessions) {
      await cancelForSession(session.id);
    }

    final nextPending = plan.sessions
        .where((x) => x.completedAtUtc == null)
        .toList()
      ..sort((a, b) => a.scheduledAtUtc.compareTo(b.scheduledAtUtc));

    if (nextPending.isEmpty) return;

    final session = nextPending.first;

    final reminderAt = session.scheduledAtUtc
        .toLocal()
        .subtract(const Duration(minutes: _sessionReminderOffsetMinutes));

    if (reminderAt.isBefore(DateTime.now())) {
      return;
    }

    await LocalNotificationService.instance.schedule(
      id: notificationIdForSession(session.id),
      title: 'MentoraX Reminder',
      body: 'Your next study session is coming up in '
          '$_sessionReminderOffsetMinutes minutes.',
      scheduledAt: reminderAt,
      payload: 'plan:${plan.id}:session:${session.id}',
    );
  }
}