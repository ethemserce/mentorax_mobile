import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentorax/core/notifications/study_reminder_service.dart';
import 'package:mentorax/features/progress/presentation/providers/progress_providers.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/session_timer_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../dashboard/data/models/next_session_model.dart';
import '../providers/study_session_providers.dart';
import '../../../../core/state/app_refresh_controller.dart';

class CompleteSessionPage extends ConsumerStatefulWidget {
  final NextSessionModel session;
  final int? elapsedSeconds;
  final String? initialNotes;

  const CompleteSessionPage({
    super.key,
    required this.session,
    this.elapsedSeconds,
      this.initialNotes,
  });

  @override
  ConsumerState<CompleteSessionPage> createState() =>
      _CompleteSessionPageState();
}

class _CompleteSessionPageState extends ConsumerState<CompleteSessionPage> {
  final _durationController = TextEditingController();
  late final TextEditingController _notesController;

  double _qualityScore = 4;
  double _difficultyScore = 3;
  bool _isSubmitting = false;

@override
void initState() {
  super.initState();
  _notesController = TextEditingController(
    text: widget.initialNotes ?? '',
  );
  if (widget.elapsedSeconds != null && widget.elapsedSeconds! > 0) {
    final minutes = (widget.elapsedSeconds! / 60).ceil();
    _durationController.text = minutes.toString();
  }
}

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

Future<void> _completeSession() async {
  final duration = int.tryParse(_durationController.text.trim());

  if (duration == null || duration <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enter a valid duration')),
    );
    return;
  }

  setState(() {
    _isSubmitting = true;
  });

  try {
    await ref.read(sessionDashboardRepositoryProvider).completeSession(
          sessionId: widget.session.sessionId,
          qualityScore: _qualityScore.toInt(),
          difficultyScore: _difficultyScore.toInt(),
          actualDurationMinutes: duration,
          reviewNotes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    await StudyReminderService.instance.cancelForSession(
      widget.session.sessionId,
    );

    ref.read(sessionTimerProvider.notifier).reset();

    ref.read(appRefreshControllerProvider).refreshAfterSessionCompleted(
          materialId: widget.session.materialId,
          planId: widget.session.studyPlanId,
        );

    try {
      final refreshedNextSession = await ref.refresh(nextSessionProvider.future);
      await StudyReminderService.instance.scheduleForNextSession(
        refreshedNextSession,
      );
    } catch (_) {
      // Yeni next session olmayabilir. Örneğin plan completed/cancelled olabilir.
    }

    final updatedProgress = await ref.refresh(progressSummaryProvider.future);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session completed')),
    );

    context.go(
      '/session-success',
      extra: {
        'durationMinutes': duration,
        'qualityScore': _qualityScore.toInt(),
        'streakDays': updatedProgress.currentStreakDays,
      },
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}

  String _qualityLabel() {
    switch (_qualityScore.toInt()) {
      case 0:
      case 1:
        return 'Very hard';
      case 2:
        return 'Hard';
      case 3:
        return 'Okay';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  String _difficultyLabel() {
    switch (_difficultyScore.toInt()) {
      case 1:
        return 'Very easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Medium';
      case 4:
        return 'Difficult';
      case 5:
        return 'Very difficult';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Session'),
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
                  Text(
                    session.materialTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Reflect on your learning and finish this session.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How well did you remember?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _qualityLabel(),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  Slider(
                    value: _qualityScore,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: _qualityScore.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _qualityScore = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How difficult was it?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _difficultyLabel(),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  Slider(
                    value: _difficultyScore,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _difficultyScore.toInt().toString(),
                    onChanged: (value) {
                      setState(() {
                        _difficultyScore = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _durationController,
            label: 'Actual Duration (minutes)',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _notesController,
            label: 'Notes',
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppPrimaryButton(
            text: 'Complete Session',
            onPressed: _completeSession,
            isLoading: _isSubmitting,
          ),
        ],
      ),
    );
  }
}