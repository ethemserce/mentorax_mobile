import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/state/app_refresh_controller.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_item_model.dart';
import 'package:mentorax/shared/widgets/app_confirm_dialog.dart';
import 'package:mentorax/shared/widgets/app_snackbar.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/study_plan_providers.dart';

class PlanDetailPage extends ConsumerWidget {
  final String planId;

  const PlanDetailPage({super.key, required this.planId});

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString().padLeft(4, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month.$year • $hour:$minute';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(studyPlanDetailProvider(planId));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plan Detail'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Sessions'),
              Tab(text: 'Items'),
            ],
          ),
        ),
        body: planAsync.when(
          data: (plan) {
            final status = plan.status.toLowerCase();
            final isActive = status == 'active';
            final isPaused = status == 'paused';
            final isCancelled = status == 'cancelled';
            final isCompleted = status == 'completed';

            return TabBarView(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(studyPlanDetailProvider(planId));
                    await ref.read(studyPlanDetailProvider(planId).future);
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _OverviewCard(
                        title: plan.title,
                        status: plan.status,
                        startDate: plan.startDate,
                        dailyTargetMinutes: plan.dailyTargetMinutes,
                        totalSessions: plan.totalSessions,
                        completedSessions: plan.completedSessions,
                        remainingSessions: plan.remainingSessions,
                        progress: plan.progress,
                        isActive: isActive,
                        isCancelled: isCancelled,
                        isCompleted: isCompleted,
                        isPaused: isPaused,
                        onPause: () async {
                          await ref
                              .read(studyPlanRepositoryProvider)
                              .pausePlan(plan.id);

                          ref
                              .read(appRefreshControllerProvider)
                              .refreshAfterPlanChanged(
                                materialId: plan.learningMaterialId,
                                planId: plan.id,
                              );
                        },
                        onResume: () async {
                          await ref
                              .read(studyPlanRepositoryProvider)
                              .resumePlan(plan.id);

                          ref
                              .read(appRefreshControllerProvider)
                              .refreshAfterPlanChanged(
                                materialId: plan.learningMaterialId,
                                planId: plan.id,
                              );
                        },
                        onComplete: () async {
                          final confirmed = await showAppConfirmDialog(
                            context: context,
                            title: 'Complete Plan',
                            message:
                                'Are you sure you want to complete this plan? Unfinished items will be marked as cancelled.',
                            confirmText: 'Complete',
                          );

                          if (!confirmed) return;

                          await ref
                              .read(studyPlanRepositoryProvider)
                              .completePlan(plan.id);

                          ref
                              .read(appRefreshControllerProvider)
                              .refreshAfterPlanChanged(
                                materialId: plan.learningMaterialId,
                                planId: plan.id,
                              );

                          if (!context.mounted) return;

                          showSuccessSnackBar(context, 'Plan completed');
                        },
                        onCancel: () async {
                          final confirmed = await showAppConfirmDialog(
                            context: context,
                            title: 'Cancel Plan',
                            message:
                                'Are you sure you want to cancel this plan? This action will stop future sessions for this plan.',
                            confirmText: 'Cancel Plan',
                            isDanger: true,
                          );

                          if (!confirmed) return;

                          await ref
                              .read(studyPlanRepositoryProvider)
                              .cancelPlan(plan.id);

                          ref
                              .read(appRefreshControllerProvider)
                              .refreshAfterPlanChanged(
                                materialId: plan.learningMaterialId,
                                planId: plan.id,
                              );

                          if (!context.mounted) return;

                          showSuccessSnackBar(context, 'Plan cancelled');
                        },
                      ),
                    ],
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(studyPlanDetailProvider(planId));
                    await ref.read(studyPlanDetailProvider(planId).future);
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      if (plan.sessions.isEmpty)
                        const _EmptyState(message: 'No sessions found.')
                      else
                        ...plan.sessions.map(
                          (session) => _SessionCard(
                            title: 'Session ${session.sequenceNumber}',
                            status: session.isCompleted
                                ? 'Completed'
                                : 'Pending',
                            scheduledAt: _formatDateTime(
                              session.scheduledAtUtc,
                            ),
                            plannedDurationMinutes:
                                session.plannedDurationMinutes,
                            completedAt: session.completedAtUtc == null
                                ? null
                                : _formatDateTime(session.completedAtUtc!),
                            actualDurationMinutes:
                                session.actualDurationMinutes,
                            notes: session.notes,
                          ),
                        ),
                    ],
                  ),
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(studyPlanDetailProvider(planId));
                    await ref.read(studyPlanDetailProvider(planId).future);
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      if (plan.items.isEmpty)
                        const _EmptyState(message: 'No study items found.')
                      else
                        ...plan.items.map(
                          (item) => _StudyPlanItemCard(item: item),
                        ),
                    ],
                  ),
                ),
              ],
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
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String status;
  final String startDate;
  final int dailyTargetMinutes;
  final int totalSessions;
  final int completedSessions;
  final int remainingSessions;
  final double progress;
  final bool isActive;
  final bool isPaused;
  final bool isCancelled;
  final bool isCompleted;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const _OverviewCard({
    required this.title,
    required this.status,
    required this.startDate,
    required this.dailyTargetMinutes,
    required this.totalSessions,
    required this.completedSessions,
    required this.remainingSessions,
    required this.progress,
    required this.isActive,
    required this.isPaused,
    required this.isCancelled,
    required this.isCompleted,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (progress * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Status: $status',
              style: TextStyle(
                color: isActive
                    ? AppColors.success
                    : isCancelled
                    ? AppColors.warning
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Start Date: $startDate',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Daily Target: $dailyTargetMinutes min',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _DetailMiniStat(
                    label: 'Total',
                    value: '$totalSessions',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _DetailMiniStat(
                    label: 'Completed',
                    value: '$completedSessions',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _DetailMiniStat(
                    label: 'Remaining',
                    value: '$remainingSessions',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '$progressPercent%',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (isActive || isPaused) ...[
              Row(
                children: [
                  if (isActive)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPause,
                        child: const Text('Pause'),
                      ),
                    ),
                  if (isPaused)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onResume,
                        child: const Text('Resume'),
                      ),
                    ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onComplete,
                      icon: const Icon(Icons.done_all_outlined),
                      label: const Text('Complete'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ] else if (isCancelled) ...[
              const _StatusInfoBox(
                message: 'This plan has been cancelled.',
                color: AppColors.warning,
              ),
            ] else if (isCompleted) ...[
              const _StatusInfoBox(
                message: 'This plan has been completed.',
                color: AppColors.success,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String title;
  final String status;
  final String scheduledAt;
  final int plannedDurationMinutes;
  final String? completedAt;
  final int? actualDurationMinutes;
  final String? notes;

  const _SessionCard({
    required this.title,
    required this.status,
    required this.scheduledAt,
    required this.plannedDurationMinutes,
    this.completedAt,
    this.actualDurationMinutes,
    this.notes,
  });

  bool get isCompleted => status.toLowerCase() == 'completed';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _StatusPill(
                    label: title,
                    color: isCompleted ? AppColors.success : AppColors.warning,
                  ),
                  const Spacer(),
                  Text(
                    status,
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.success
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Scheduled: $scheduledAt',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Planned Duration: $plannedDurationMinutes min',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              if (completedAt != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Completed At: $completedAt',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
              if (actualDurationMinutes != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Actual Duration: $actualDurationMinutes min',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
              if (notes != null && notes!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  notes!,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyPlanItemCard extends StatelessWidget {
  final StudyPlanItemModel item;

  const _StudyPlanItemCard({required this.item});

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();

    return '${local.day.toString().padLeft(2, '0')}.'
        '${local.month.toString().padLeft(2, '0')}.'
        '${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(String status) {
    final value = status.toLowerCase();

    if (value == 'completed') return AppColors.success;
    if (value == 'inprogress') return AppColors.primary;
    if (value == 'cancelled') return AppColors.warning;
    if (value == 'skipped') return AppColors.warning;

    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    final chunk = item.materialChunk;
    final firstSession = item.sessions.isEmpty ? null : item.sessions.first;
    final statusColor = _statusColor(item.status);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(item.orderNo.toString())),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.itemType,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _StatusPill(label: item.status, color: statusColor),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (chunk != null) ...[
              Text(
                'Material Chunk',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                chunk.title ?? 'Chunk ${chunk.orderNo}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                chunk.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Row(
              children: [
                const Icon(Icons.timer_outlined, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text('${item.durationMinutes} min'),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.schedule_outlined, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  firstSession == null
                      ? _formatDateTime(item.plannedDateUtc)
                      : _formatDateTime(firstSession.scheduledAtUtc),
                ),
              ],
            ),
            if (firstSession != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.event_available_outlined, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Session: ${firstSession.status}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailMiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _DetailMiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StatusInfoBox extends StatelessWidget {
  final String message;
  final Color color;

  const _StatusInfoBox({required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          message,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
