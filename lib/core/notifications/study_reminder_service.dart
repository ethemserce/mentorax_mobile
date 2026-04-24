import 'package:flutter/material.dart';

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

Future<void> scheduleForNextSession(
  NextSessionModel session, {
  void Function({
    required String action,
    String? sessionId,
    String? planId,
    DateTime? sessionTime,
    DateTime? reminderTime,
    String? message,
  })? onDebug,
}) async {
  final scheduledAt = session.scheduledAtUtc.toLocal();
  final reminderAt = scheduledAt.subtract(
    const Duration(minutes: _sessionReminderOffsetMinutes),
  );

  debugPrint('--- SCHEDULE NEXT SESSION ---');
  debugPrint('SessionId: ${session.sessionId}');
  debugPrint('ScheduledAtLocal: $scheduledAt');
  debugPrint('ReminderAtLocal: $reminderAt');
  debugPrint('NowLocal: ${DateTime.now()}');

  if (reminderAt.isBefore(DateTime.now())) {
    onDebug?.call(
      action: 'Skipped',
      sessionId: session.sessionId,
      sessionTime: scheduledAt,
      reminderTime: reminderAt,
      message: 'Reminder time is in the past.',
    );

    debugPrint('❌ Reminder skipped because reminder time is in the past.');
    return;
  }

  await LocalNotificationService.instance.schedule(
    id: notificationIdForSession(session.sessionId),
    title: 'MentoraX Reminder',
    body: '${session.materialTitle} study session is ready.',
    scheduledAt: reminderAt,
    payload: 'next_session:${session.sessionId}',
  );

  onDebug?.call(
    action: 'Scheduled',
    sessionId: session.sessionId,
    sessionTime: scheduledAt,
    reminderTime: reminderAt,
    message: 'Reminder scheduled successfully.',
  );

  debugPrint('✅ Reminder scheduled successfully.');
}
  Future<void> cancelForSession(String sessionId) async {
     debugPrint('--- CANCEL SESSION REMINDER ---');
  debugPrint('SessionId: $sessionId');
    await LocalNotificationService.instance
        .cancel(notificationIdForSession(sessionId));
          debugPrint('Reminder cancelled for session $sessionId');
  }

Future<void> rescheduleFromPlanDetail(
  StudyPlanDetailModel plan, {
  void Function({
    required String action,
    String? sessionId,
    String? planId,
    DateTime? sessionTime,
    DateTime? reminderTime,
    String? message,
  })? onDebug,
}) async {
      debugPrint('--- RESCHEDULE FROM PLAN DETAIL ---');
  debugPrint('PlanId: ${plan.id}');
  debugPrint('TotalSessions: ${plan.sessions.length}');
    for (final session in plan.sessions) {
      await cancelForSession(session.id);
    }

    final nextPending = plan.sessions
        .where((x) => x.completedAtUtc == null)
        .toList()
      ..sort((a, b) => a.scheduledAtUtc.compareTo(b.scheduledAtUtc));

    if (nextPending.isEmpty) {
          debugPrint('No pending session found. No reminder scheduled.');
      return;
      }

    final session = nextPending.first;

    final reminderAt = session.scheduledAtUtc
        .toLocal()
        .subtract(const Duration(minutes: _sessionReminderOffsetMinutes));

  debugPrint('NextPendingSessionId: ${session.id}');
  debugPrint('NextPendingScheduledAtLocal: ${session.scheduledAtUtc.toLocal()}');
  debugPrint('ReminderAtLocal: $reminderAt');
  debugPrint('NowLocal: ${DateTime.now()}');

 if (reminderAt.isBefore(DateTime.now())) {
  debugPrint('❌ Reminder SKIPPED (past time)');
  debugPrint('Now: ${DateTime.now()}');
  debugPrint('ReminderAt: $reminderAt');
  debugPrint('SessionAt: ${session.scheduledAtUtc.toLocal()}');
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
      debugPrint('Reminder scheduled from plan detail for session ${session.id}');

    onDebug?.call(
  action: 'Scheduled',
  sessionId: session.id,
  planId: plan.id,
  sessionTime: session.scheduledAtUtc.toLocal(),
  reminderTime: reminderAt,
  message: 'Reminder scheduled successfully.',
);
  }
}