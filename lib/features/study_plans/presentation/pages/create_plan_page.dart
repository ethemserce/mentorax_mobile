import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/notifications/reminder_debug_provider.dart';
import 'package:mentorax/core/notifications/reminder_debug_state.dart';
import 'package:mentorax/core/notifications/study_reminder_service.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/state/app_refresh_controller.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../materials/presentation/providers/material_providers.dart';
import '../../data/models/create_study_plan_request.dart';
import '../providers/study_plan_providers.dart';

class CreatePlanPage extends ConsumerStatefulWidget {
  final String materialId;

  const CreatePlanPage({
    super.key,
    required this.materialId,
  });

  @override
  ConsumerState<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends ConsumerState<CreatePlanPage> {
  final _titleController = TextEditingController(text: 'Auto Plan');
  final _dailyTargetController = TextEditingController(text: '30');

  int _preferredHour = DateTime.now().hour;
  int _preferredMinute = DateTime.now().minute;

  bool _isLoading = false;
  String? _generalError;

  @override
  void dispose() {
    _titleController.dispose();
    _dailyTargetController.dispose();
    super.dispose();
  }

  String _toDateOnlyString(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> _createPlan() async {
    final title = _titleController.text.trim();
    final dailyTarget = int.tryParse(_dailyTargetController.text.trim());

    if (title.isEmpty || dailyTarget == null || dailyTarget <= 0) {
      setState(() {
        _generalError = 'Please fill required fields correctly.';
      });
      return;
    }

    if (_preferredHour < 0 || _preferredHour > 23) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferred hour must be between 0 and 23')),
      );
      return;
    }

    if (_preferredMinute < 0 || _preferredMinute > 59) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferred minute must be between 0 and 59'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      final chunks = await ref.read(
        materialChunksProvider(widget.materialId).future,
      );

      if (chunks.isEmpty) {
        setState(() {
          _generalError =
              'No chunks found for this material. Please create at least one chunk.';
        });
        return;
      }

      final dayOffsets = List.generate(
        chunks.length,
        (index) => index,
      );

      final request = CreateStudyPlanRequest(
        learningMaterialId: widget.materialId,
        title: title,
        startDate: _toDateOnlyString(DateTime.now()),
        dailyTargetMinutes: dailyTarget,
        preferredHour: _preferredHour,
        preferredMinute: _preferredMinute,
        dayOffsets: dayOffsets,
      );

      final createdPlan = await ref.read(studyPlanServiceProvider).createPlan(
            request,
          );

      final detail = await ref.read(studyPlanServiceProvider).getPlanById(
            createdPlan.id,
          );

      await StudyReminderService.instance.rescheduleFromPlanDetail(
        detail,
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

      if (!mounted) return;

      ref.read(appRefreshControllerProvider).refreshAfterPlanCreated();

      ref.invalidate(materialDetailProvider(widget.materialId));
      ref.invalidate(materialListProvider);
      ref.invalidate(materialChunksProvider(widget.materialId));
      ref.invalidate(studyPlansProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan created')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _generalError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chunksAsync = ref.watch(materialChunksProvider(widget.materialId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Study Plan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Schedule your study',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'MentoraX will create sessions from your material chunks.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          AppTextField(
            controller: _titleController,
            label: 'Plan Title',
          ),

          const SizedBox(height: AppSpacing.md),

          AppTextField(
            controller: _dailyTargetController,
            label: 'Daily Target Minutes',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: AppSpacing.md),

          DropdownButtonFormField<int>(
            initialValue: _preferredHour,
            decoration: const InputDecoration(
              labelText: 'Preferred Hour',
            ),
            items: List.generate(
              24,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(index.toString().padLeft(2, '0')),
              ),
            ),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _preferredHour = value;
              });
            },
          ),

          const SizedBox(height: AppSpacing.md),

          DropdownButtonFormField<int>(
            initialValue: _preferredMinute,
            decoration: const InputDecoration(
              labelText: 'Preferred Minute',
            ),
            items: List.generate(
              60,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(index.toString().padLeft(2, '0')),
              ),
            ),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _preferredMinute = value;
              });
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          const Text(
            'The first session will be scheduled for today at the selected time. '
            'Other chunks will be scheduled on following days.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          const _SectionTitle(
            title: 'Study Chunks',
            subtitle: 'These chunks will become study sessions.',
          ),

          chunksAsync.when(
            data: (chunks) {
              if (chunks.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'No chunks found',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Go back to Material Detail and create at least one chunk before creating a plan.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_tree_outlined,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              '${chunks.length} chunks will be scheduled',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...chunks.map(
                    (chunk) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                child: Text(chunk.orderNo.toString()),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chunk.title ?? 'Chunk ${chunk.orderNo}',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      chunk.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      '${chunk.estimatedStudyMinutes} min • Difficulty ${chunk.difficultyLevel}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  error.toString(),
                  style: const TextStyle(color: AppColors.danger),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          if (_generalError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                _generalError!,
                style: const TextStyle(color: AppColors.danger),
              ),
            ),

          const SizedBox(height: AppSpacing.md),

          AppPrimaryButton(
            text: 'Create Plan',
            onPressed: _isLoading ? null : _createPlan,
            isLoading: _isLoading,
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
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
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}