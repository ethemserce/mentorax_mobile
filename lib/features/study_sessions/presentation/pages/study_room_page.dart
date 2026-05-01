import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentorax/features/dashboard/data/models/next_session_model.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/study_session_providers.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class StudyRoomPage extends ConsumerStatefulWidget {
  final String sessionId;

  const StudyRoomPage({super.key, required this.sessionId});

  @override
  ConsumerState<StudyRoomPage> createState() => _StudyRoomPageState();
}

class _StudyRoomPageState extends ConsumerState<StudyRoomPage>
    with SingleTickerProviderStateMixin {
  final _notesController = TextEditingController();

  late final TabController _tabController;

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  int _confidenceScore = 3;
  bool _markImportant = false;
  bool _needReview = false;
  bool _needExamples = false;
  bool _hardToUnderstand = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
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

  String get _confidenceLabel {
    switch (_confidenceScore) {
      case 1:
        return 'Very low';
      case 2:
        return 'Low';
      case 3:
        return 'Medium';
      case 4:
        return 'Good';
      case 5:
        return 'Very good';
      default:
        return 'Medium';
    }
  }

  String _buildCombinedNotes() {
    final userNotes = _notesController.text.trim();

    final selfCheck = <String>[
      'Self Check:',
      '- Confidence: $_confidenceScore/5 ($_confidenceLabel)',
      if (_markImportant) '- Marked as important',
      if (_needReview) '- Needs review',
      if (_needExamples) '- Needs more examples',
      if (_hardToUnderstand) '- Hard to understand',
    ];

    if (userNotes.isEmpty) {
      return selfCheck.join('\n');
    }

    return '$userNotes\n\n${selfCheck.join('\n')}';
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(
      studySessionDetailProvider(widget.sessionId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Study Room')),
      body: sessionAsync.when(
        data: (session) {
          final progress = _progressValue(session.plannedDurationMinutes);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _StudyHeaderCard(
                    planTitle: session.planTitle,
                    materialTitle: session.materialTitle,
                    sessionNumber: session.sequenceNumber,
                    itemType: session.itemType ?? 'Study',
                    scheduledAt: _formatDateTime(session.scheduledAtUtc),
                    durationMinutes: session.plannedDurationMinutes,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Expanded(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Material(
                            color: AppColors.surface,
                            child: TabBar(
                              controller: _tabController,
                              labelColor: AppColors.primary,
                              unselectedLabelColor: AppColors.textSecondary,
                              indicatorColor: AppColors.primary,
                              tabs: const [
                                Tab(
                                  icon: Icon(Icons.menu_book_outlined),
                                  text: 'Content',
                                ),
                                Tab(
                                  icon: Icon(Icons.edit_note_outlined),
                                  text: 'Notes',
                                ),
                                Tab(
                                  icon: Icon(Icons.fact_check_outlined),
                                  text: 'Check',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _ContentTab(
                                  title: session.chunkTitle,
                                  content: session.chunkContent,
                                ),
                                _NotesTab(controller: _notesController),
                                _SelfCheckTab(
                                  confidenceScore: _confidenceScore,
                                  confidenceLabel: _confidenceLabel,
                                  markImportant: _markImportant,
                                  needReview: _needReview,
                                  needExamples: _needExamples,
                                  hardToUnderstand: _hardToUnderstand,
                                  onConfidenceChanged: (value) {
                                    setState(() {
                                      _confidenceScore = value;
                                    });
                                  },
                                  onMarkImportantChanged: (value) {
                                    setState(() {
                                      _markImportant = value;
                                    });
                                  },
                                  onNeedReviewChanged: (value) {
                                    setState(() {
                                      _needReview = value;
                                    });
                                  },
                                  onNeedExamplesChanged: (value) {
                                    setState(() {
                                      _needExamples = value;
                                    });
                                  },
                                  onHardToUnderstandChanged: (value) {
                                    setState(() {
                                      _hardToUnderstand = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _CompactTimerPanel(
                    elapsedText: _formatElapsed(_elapsedSeconds),
                    plannedMinutes: session.plannedDurationMinutes,
                    progress: progress,
                    isRunning: _isRunning,
                    onStartPause: _isRunning ? _pauseTimer : _startTimer,
                    onReset: _resetTimer,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
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
                              isDue: session.scheduledAtUtc.toLocal().isBefore(
                                DateTime.now(),
                              ),
                            ),
                            'notes': _buildCombinedNotes(),
                            'elapsedSeconds': _elapsedSeconds,
                          },
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Continue to Complete Session'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class _StudyHeaderCard extends StatelessWidget {
  final String planTitle;
  final String materialTitle;
  final int sessionNumber;
  final String itemType;
  final String scheduledAt;
  final int durationMinutes;

  const _StudyHeaderCard({
    required this.planTitle,
    required this.materialTitle,
    required this.sessionNumber,
    required this.itemType,
    required this.scheduledAt,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.school_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    materialTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    planTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      _SmallChip(label: 'Session $sessionNumber'),
                      _SmallChip(label: itemType),
                      _SmallChip(label: '$durationMinutes min'),
                      _SmallChip(label: scheduledAt),
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

class _ContentTab extends StatelessWidget {
  final String? title;
  final String? content;

  const _ContentTab({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final text = content?.trim();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title?.trim().isNotEmpty == true ? title! : 'Study Content',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: SingleChildScrollView(
                child: Text(
                  text?.isNotEmpty == true
                      ? text!
                      : 'No content found for this session.',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.6,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesTab extends StatelessWidget {
  final TextEditingController controller;

  const _NotesTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Notes',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Write what you understood or found difficult.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: TextField(
              controller: controller,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Example: I understood the main idea, but...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelfCheckTab extends StatelessWidget {
  final int confidenceScore;
  final String confidenceLabel;
  final bool markImportant;
  final bool needReview;
  final bool needExamples;
  final bool hardToUnderstand;
  final ValueChanged<int> onConfidenceChanged;
  final ValueChanged<bool> onMarkImportantChanged;
  final ValueChanged<bool> onNeedReviewChanged;
  final ValueChanged<bool> onNeedExamplesChanged;
  final ValueChanged<bool> onHardToUnderstandChanged;

  const _SelfCheckTab({
    required this.confidenceScore,
    required this.confidenceLabel,
    required this.markImportant,
    required this.needReview,
    required this.needExamples,
    required this.hardToUnderstand,
    required this.onConfidenceChanged,
    required this.onMarkImportantChanged,
    required this.onNeedReviewChanged,
    required this.onNeedExamplesChanged,
    required this.onHardToUnderstandChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Self Check',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Quickly mark how well you understood this chunk.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Text(
                'Confidence',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$confidenceScore/5 • $confidenceLabel',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Slider(
            value: confidenceScore.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: confidenceLabel,
            onChanged: (value) {
              onConfidenceChanged(value.toInt());
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  FilterChip(
                    label: const Text('Important'),
                    selected: markImportant,
                    onSelected: onMarkImportantChanged,
                  ),
                  FilterChip(
                    label: const Text('Need Review'),
                    selected: needReview,
                    onSelected: onNeedReviewChanged,
                  ),
                  FilterChip(
                    label: const Text('Need Examples'),
                    selected: needExamples,
                    onSelected: onNeedExamplesChanged,
                  ),
                  FilterChip(
                    label: const Text('Hard to Understand'),
                    selected: hardToUnderstand,
                    onSelected: onHardToUnderstandChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactTimerPanel extends StatelessWidget {
  final String elapsedText;
  final int plannedMinutes;
  final double progress;
  final bool isRunning;
  final VoidCallback onStartPause;
  final VoidCallback onReset;

  const _CompactTimerPanel({
    required this.elapsedText,
    required this.plannedMinutes,
    required this.progress,
    required this.isRunning,
    required this.onStartPause,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  elapsedText,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$plannedMinutes min target',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                IconButton.filled(
                  onPressed: onStartPause,
                  icon: Icon(
                    isRunning
                        ? Icons.pause_outlined
                        : Icons.play_arrow_outlined,
                  ),
                ),
                IconButton(
                  onPressed: onReset,
                  icon: const Icon(Icons.restart_alt_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;

  const _SmallChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
