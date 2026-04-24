import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/notifications/reminder_debug_state.dart';
import 'package:mentorax/core/notifications/study_reminder_service.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/study_session_providers.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/notifications/local_notification_service.dart';
import '../../../../core/notifications/reminder_debug_provider.dart';
import '../../../../shared/widgets/app_primary_button.dart';

class ReminderDebugPage extends ConsumerWidget {
  const ReminderDebugPage({super.key});

  String _format(DateTime? value) {
    if (value == null) return '-';
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}.'
        '${local.month.toString().padLeft(2, '0')}.'
        '${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reminderDebugProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Debug'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RowText(label: 'Last Action', value: state.lastAction ?? '-'),
                  _RowText(label: 'Message', value: state.message ?? '-'),
                  _RowText(label: 'Plan Id', value: state.planId ?? '-'),
                  _RowText(label: 'Session Id', value: state.sessionId ?? '-'),
                  _RowText(label: 'Session Time', value: _format(state.sessionTime)),
                  _RowText(label: 'Reminder Time', value: _format(state.reminderTime)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            text: 'Send Test Notification Now',
            onPressed: () async {
              await LocalNotificationService.instance.showNow(
                id: 9999,
                title: 'MentoraX Test',
                body: 'Local notification is working.',
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
AppPrimaryButton(
  text: 'Schedule Current Next Session Reminder',
  onPressed: () async {
    try {
      final nextSession = await ref.read(nextSessionProvider.future);

      await StudyReminderService.instance.scheduleForNextSession(
        nextSession,
        onDebug: ({
          required action,
          sessionId,
          planId,
          sessionTime,
          reminderTime,
          message,
        }) {
          ref.read(reminderDebugProvider.notifier).update(
                ReminderDebugState(
                  lastAction: action,
                  sessionId: sessionId,
                  planId: planId,
                  sessionTime: sessionTime,
                  reminderTime: reminderTime,
                  message: message,
                ),
              );
        },
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminder check completed.')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No next session found: $e')),
      );
    }
  },
),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            text: 'Cancel All Reminders',
            onPressed: () async {
              await LocalNotificationService.instance.cancelAll();
              ref.read(reminderDebugProvider.notifier).clear();
            },
          ),
        ],
      ),
    );
  }
}

class _RowText extends StatelessWidget {
  final String label;
  final String value;

  const _RowText({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Text(value),
        ],
      ),
    );
  }
}