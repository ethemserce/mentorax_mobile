import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mentorax/core/notifications/study_reminder_service.dart';
import 'package:mentorax/core/state/app_refresh_controller.dart';
import 'package:mentorax/features/progress/presentation/providers/progress_providers.dart';
import 'package:mentorax/features/study_sessions/data/session_elapsed_time.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/session_timer_providers.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../dashboard/data/models/next_session_model.dart';
import '../providers/study_session_providers.dart';

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
  late final int _trackedElapsedSeconds;

  int _qualityScore = 4;
  int _difficultyScore = 3;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _notesController = TextEditingController(text: widget.initialNotes ?? '');
    final providedElapsedSeconds = widget.elapsedSeconds ?? 0;
    _trackedElapsedSeconds = providedElapsedSeconds > 0
        ? providedElapsedSeconds
        : SessionElapsedTime.secondsSinceStart(
            startedAtUtc: widget.session.startedAtUtc,
          );

    if (_trackedElapsedSeconds > 0) {
      final minutes = SessionElapsedTime.roundedMinutes(_trackedElapsedSeconds);
      _durationController.text = minutes.toString();
    } else {
      _durationController.text = widget.session.estimatedMinutes.toString();
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String get _qualityLabel {
    switch (_qualityScore) {
      case 0:
        return 'Forgot';
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
        return 'Good';
    }
  }

  String get _difficultyLabel {
    switch (_difficultyScore) {
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
        return 'Medium';
    }
  }

  String _formatElapsedSeconds(int? seconds) {
    if (seconds == null || seconds <= 0) return 'Not tracked';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  int? _durationMinutes() {
    return int.tryParse(_durationController.text.trim());
  }

  Future<void> _completeSession() async {
    if (_isSubmitting) return;

    final duration = int.tryParse(_durationController.text.trim());

    if (duration == null || duration <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid duration')));
      return;
    }

    final expectedMinutes = widget.session.estimatedMinutes <= 0
        ? 1
        : widget.session.estimatedMinutes;

    var minimumRequiredMinutes = (expectedMinutes * 0.5).ceil();

    if (minimumRequiredMinutes > 5) {
      minimumRequiredMinutes = 5;
    }

    if (minimumRequiredMinutes < 1) {
      minimumRequiredMinutes = 1;
    }

    if (duration < minimumRequiredMinutes) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Continue studying'),
            content: Text(
              'You studied for only $duration minute(s). '
              'This session is planned for about $expectedMinutes minute(s). '
              'Please continue a little more before completing it.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Go back'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(sessionDashboardRepositoryProvider)
          .completeSession(
            sessionId: widget.session.sessionId,
            qualityScore: _qualityScore,
            difficultyScore: _difficultyScore,
            actualDurationMinutes: duration,
            reviewNotes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      await StudyReminderService.instance.cancelForSession(
        widget.session.sessionId,
      );

      ref.read(sessionTimerProvider.notifier).reset();

      ref
          .read(appRefreshControllerProvider)
          .refreshAfterSessionCompleted(
            materialId: widget.session.materialId,
            planId: widget.session.studyPlanId,
          );

      try {
        final refreshedNextSession = await ref.refresh(
          nextSessionProvider.future,
        );
        await StudyReminderService.instance.scheduleForNextSession(
          refreshedNextSession,
        );
      } catch (_) {
        // New next session may not exist.
      }

      var streakDays = 0;

      try {
        final updatedProgress = await ref.refresh(
          progressSummaryProvider.future,
        );
        streakDays = updatedProgress.currentStreakDays;
      } catch (_) {
        // Offline completion can still succeed locally before progress syncs.
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Session completed')));

      context.go(
        '/session-success',
        extra: {
          'durationMinutes': duration,
          'qualityScore': _qualityScore,
          'streakDays': streakDays,
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _setDurationFromElapsed() {
    if (_trackedElapsedSeconds <= 0) return;

    final minutes = SessionElapsedTime.roundedMinutes(_trackedElapsedSeconds);

    setState(() {
      _durationController.text = minutes.toString();
    });
  }

  void _setPlannedDuration() {
    setState(() {
      _durationController.text = widget.session.estimatedMinutes.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final duration = _durationMinutes();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Complete Session')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _HeaderCard(
              materialTitle: session.materialTitle,
              elapsedText: _formatElapsedSeconds(_trackedElapsedSeconds),
              plannedMinutes: session.estimatedMinutes,
            ),

            const SizedBox(height: AppSpacing.lg),

            _DurationCard(
              controller: _durationController,
              duration: duration,
              onUseTrackedTime: _setDurationFromElapsed,
              onUsePlannedTime: _setPlannedDuration,
            ),

            const SizedBox(height: AppSpacing.md),

            _ScoreCard(
              title: 'How well did you remember?',
              subtitle: 'This affects when MentoraX schedules the next review.',
              score: _qualityScore,
              minScore: 0,
              maxScore: 5,
              label: _qualityLabel,
              labels: const {
                0: 'Forgot',
                1: 'Very hard',
                2: 'Hard',
                3: 'Okay',
                4: 'Good',
                5: 'Excellent',
              },
              onChanged: (value) {
                setState(() {
                  _qualityScore = value;
                });
              },
            ),

            const SizedBox(height: AppSpacing.md),

            _ScoreCard(
              title: 'How difficult was it?',
              subtitle:
                  'Use this to tell the system how heavy this chunk felt.',
              score: _difficultyScore,
              minScore: 1,
              maxScore: 5,
              label: _difficultyLabel,
              labels: const {
                1: 'Very easy',
                2: 'Easy',
                3: 'Medium',
                4: 'Difficult',
                5: 'Very difficult',
              },
              onChanged: (value) {
                setState(() {
                  _difficultyScore = value;
                });
              },
            ),

            const SizedBox(height: AppSpacing.md),

            _NotesCard(controller: _notesController),

            const SizedBox(height: AppSpacing.lg),

            _SummaryCard(
              duration: duration,
              qualityLabel: _qualityLabel,
              difficultyLabel: _difficultyLabel,
            ),

            const SizedBox(height: AppSpacing.lg),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _completeSession,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Complete Session'),
            ),

            const SizedBox(height: AppSpacing.sm),

            TextButton(
              onPressed: _isSubmitting ? null : () => context.pop(),
              child: const Text('Back to Study Room'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String materialTitle;
  final String elapsedText;
  final int plannedMinutes;

  const _HeaderCard({
    required this.materialTitle,
    required this.elapsedText,
    required this.plannedMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 30,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Finish your session',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    materialTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _InfoChip(
                        icon: Icons.timer_outlined,
                        label: 'Tracked: $elapsedText',
                      ),
                      _InfoChip(
                        icon: Icons.schedule_outlined,
                        label: 'Planned: $plannedMinutes min',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  final TextEditingController controller;
  final int? duration;
  final VoidCallback onUseTrackedTime;
  final VoidCallback onUsePlannedTime;

  const _DurationCard({
    required this.controller,
    required this.duration,
    required this.onUseTrackedTime,
    required this.onUsePlannedTime,
  });

  @override
  Widget build(BuildContext context) {
    final hasInvalidDuration = duration == null || duration! <= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              icon: Icons.timer_outlined,
              title: 'Actual duration',
              subtitle: 'Confirm how many minutes you studied.',
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Duration in minutes',
                errorText: hasInvalidDuration ? 'Enter a valid duration' : null,
                border: const OutlineInputBorder(),
                suffixText: 'min',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                OutlinedButton.icon(
                  onPressed: onUseTrackedTime,
                  icon: const Icon(Icons.timer_outlined),
                  label: const Text('Use tracked time'),
                ),
                OutlinedButton.icon(
                  onPressed: onUsePlannedTime,
                  icon: const Icon(Icons.event_available_outlined),
                  label: const Text('Use planned time'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int score;
  final int minScore;
  final int maxScore;
  final String label;
  final Map<int, String> labels;
  final ValueChanged<int> onChanged;

  const _ScoreCard({
    required this.title,
    required this.subtitle,
    required this.score,
    required this.minScore,
    required this.maxScore,
    required this.label,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final values = List.generate(
      maxScore - minScore + 1,
      (index) => minScore + index,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.psychology_alt_outlined,
              title: title,
              subtitle: subtitle,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    '$score/5',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: values.map((value) {
                final selected = value == score;

                return ChoiceChip(
                  label: Text(labels[value] ?? value.toString()),
                  selected: selected,
                  onSelected: (_) => onChanged(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final TextEditingController controller;

  const _NotesCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              icon: Icons.edit_note_outlined,
              title: 'Review notes',
              subtitle: 'You can edit the notes coming from Study Room.',
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'What did you learn? What was difficult?',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int? duration;
  final String qualityLabel;
  final String difficultyLabel;

  const _SummaryCard({
    required this.duration,
    required this.qualityLabel,
    required this.difficultyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session summary',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SummaryRow(
              label: 'Duration',
              value: duration == null || duration! <= 0
                  ? 'Not set'
                  : '$duration min',
            ),
            _SummaryRow(label: 'Memory quality', value: qualityLabel),
            _SummaryRow(label: 'Difficulty', value: difficultyLabel),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
