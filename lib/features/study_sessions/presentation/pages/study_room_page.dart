import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentorax/features/dashboard/data/models/next_session_model.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/study_session_providers.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/section_title.dart';

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

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _elapsedSeconds = 0;
    });
  }

  String _formatElapsed(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();

    return '${local.day.toString().padLeft(2, '0')}.'
        '${local.month.toString().padLeft(2, '0')}.'
        '${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  double _progressValue(int plannedMinutes) {
    final plannedSeconds = plannedMinutes * 60;
    if (plannedSeconds <= 0) return 0;

    return (_elapsedSeconds / plannedSeconds).clamp(0, 1).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(
      studySessionDetailProvider(widget.sessionId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Study Room'),
      ),
      body: sessionAsync.when(
        data: (session) {
          final progress = _progressValue(session.plannedDurationMinutes);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              SectionTitle(
                title: 'Focus Session',
                subtitle: 'Read, take notes, and complete your review.',
                trailing: AppChip(
                  label: session.status,
                  icon: Icons.circle_outlined,
                ),
              ),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.planTitle,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      session.materialTitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        AppChip(
                          label: 'Session ${session.sequenceNumber}',
                          icon: Icons.layers_outlined,
                        ),
                        AppChip(
                          label: session.itemType ?? 'Study',
                          icon: Icons.auto_stories_outlined,
                        ),
                        AppChip(
                          label: '${session.plannedDurationMinutes} min',
                          icon: Icons.timer_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_outlined,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _formatDateTime(session.scheduledAtUtc),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              const SectionTitle(
                title: 'Learning Content',
                subtitle: 'This is the chunk you should study now.',
              ),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.chunkTitle?.trim().isNotEmpty == true
                          ? session.chunkTitle!
                          : 'Study Chunk',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        session.chunkContent?.trim().isNotEmpty == true
                            ? session.chunkContent!
                            : 'No content found for this session.',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          height: 1.7,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              const SectionTitle(
                title: 'Focus Timer',
                subtitle: 'Track how long you actually study.',
              ),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        _formatElapsed(_elapsedSeconds),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: Text(
                        '${session.plannedDurationMinutes} minutes planned',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isRunning ? _pauseTimer : _startTimer,
                            icon: Icon(
                              _isRunning
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                            ),
                            label: Text(_isRunning ? 'Pause' : 'Start'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetTimer,
                            icon: const Icon(Icons.restart_alt_outlined),
                            label: const Text('Reset'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              const SectionTitle(
                title: 'My Notes',
                subtitle: 'Write what you understood or found difficult.',
              ),

              AppCard(
                child: TextField(
                  controller: _notesController,
                  minLines: 5,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Example: I understood the main idea, but...',
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              ElevatedButton.icon(
                onPressed: () {
                  _pauseTimer();

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
                        isDue: session.scheduledAtUtc
                            .toLocal()
                            .isBefore(DateTime.now()),
                      ),
                      'notes': _notesController.text.trim(),
                      'elapsedSeconds': _elapsedSeconds,
                    },
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Continue to Complete Session'),
              ),

              const SizedBox(height: AppSpacing.xl),
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