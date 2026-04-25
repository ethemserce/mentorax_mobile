import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentorax/features/dashboard/data/models/next_session_model.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/study_session_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class StudyRoomPage extends ConsumerStatefulWidget {
  final String sessionId;

  const StudyRoomPage({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<StudyRoomPage> createState() => _StudyRoomPageState();
}

class _StudyRoomPageState extends ConsumerState<StudyRoomPage> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    return '${local.day.toString().padLeft(2, '0')}.'
        '${local.month.toString().padLeft(2, '0')}.'
        '${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(
      studySessionDetailProvider(widget.sessionId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Room'),
      ),
      body: sessionAsync.when(
        data: (session) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.planTitle,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        session.materialTitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          _InfoChip(label: 'Session ${session.sequenceNumber}'),
                          _InfoChip(label: session.itemType ?? 'Study'),
                          _InfoChip(label: '${session.plannedDurationMinutes} min'),
                          _InfoChip(label: session.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Scheduled: ${_formatDateTime(session.scheduledAtUtc)}',
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
                        'Learning Content',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (session.chunkTitle != null &&
                          session.chunkTitle!.trim().isNotEmpty) ...[
                        Text(
                          session.chunkTitle!,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      Text(
                        session.chunkContent?.trim().isNotEmpty == true
                            ? session.chunkContent!
                            : 'No content found for this session.',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          height: 1.6,
                          fontSize: 16,
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
                        'My Notes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _notesController,
                        minLines: 4,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: 'Write what you understood or found difficult...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                        'Focus Timer',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        '${session.plannedDurationMinutes} minutes planned',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      LinearProgressIndicator(
                        value: 0,
                        minHeight: 10,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

ElevatedButton.icon(
  onPressed: () {
    context.push(
      '/session-complete',
      extra: {
        'session': NextSessionModel(
          sessionId: session.id,
          studyPlanId: session.studyPlanId,
          materialId: session.learningMaterialId,
          materialTitle: session.materialTitle,
          scheduledAtUtc: session.scheduledAtUtc,
          startedAtUtc: null,
          estimatedMinutes: session.plannedDurationMinutes,
          isDue: session.scheduledAtUtc.toLocal().isBefore(DateTime.now()),
        ),
        'notes': _notesController.text.trim(),
      },
    );
  },
  icon: const Icon(Icons.check_circle_outline),
  label: const Text('Continue to Complete Session'),
),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}