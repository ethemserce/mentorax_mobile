import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/notifications/local_notification_service.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final _minutesController = TextEditingController(text: '1');

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  Future<void> _sendInstant() async {
    await LocalNotificationService.instance.showNow(
      id: 1001,
      title: 'MentoraX',
      body: 'Instant local notification test',
      payload: 'instant_test',
    );
  }

  Future<void> _scheduleReminder() async {
    final minutes = int.tryParse(_minutesController.text.trim()) ?? 1;
    final scheduledAt = DateTime.now().add(Duration(minutes: minutes));

    await LocalNotificationService.instance.schedule(
      id: 1002,
      title: 'MentoraX Reminder',
      body: 'Your study reminder is ready.',
      scheduledAt: scheduledAt,
      payload: 'scheduled_test',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder scheduled for $minutes minute(s) later.'),
      ),
    );
  }

  Future<void> _cancelAll() async {
    await LocalNotificationService.instance.cancelAll();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All scheduled notifications cancelled.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppPrimaryButton(
            text: 'Send Instant Notification',
            onPressed: _sendInstant,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _minutesController,
            label: 'Schedule after minutes',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            text: 'Schedule Reminder',
            onPressed: _scheduleReminder,
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            text: 'Cancel All Notifications',
            onPressed: _cancelAll,
          ),
        ],
      ),
    );
  }
}