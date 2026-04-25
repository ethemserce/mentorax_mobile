import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/features/study_plans/data/models/study_plan_item_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/study_plan_providers.dart';

class PlanDetailPage extends ConsumerWidget {
  final String planId;

  const PlanDetailPage({
    super.key,
    required this.planId,
  });

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Detail'),
      ),
      body: planAsync.when(
        data: (plan) {
          final status = plan.status.toLowerCase();
          final isActive = status == 'active';
          final isPaused = status == 'paused';
          final isCancelled = status == 'cancelled';
          final isCompleted = status == 'completed';

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(studyPlanDetailProvider(planId));
              await ref.read(studyPlanDetailProvider(planId).future);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Status: ${plan.status}',
                          style: TextStyle(
                            color: isActive
                                ? AppColors.success
                                : isCancelled
                                    ? AppColors.warning
                                    : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Start Date: ${plan.startDate}',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Daily Target: ${plan.dailyTargetMinutes} min',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            Expanded(
                              child: _DetailMiniStat(
                                label: 'Total',
                                value: '${plan.totalSessions}',
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _DetailMiniStat(
                                label: 'Completed',
                                value: '${plan.completedSessions}',
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _DetailMiniStat(
                                label: 'Remaining',
                                value: '${plan.remainingSessions}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: plan.progress,
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
                                    onPressed: () async {
                                      await ref
                                          .read(studyPlanServiceProvider)
                                          .pausePlan(plan.id);

                                      ref.invalidate(
                                        studyPlanDetailProvider(plan.id),
                                      );
                                      ref.invalidate(studyPlansProvider);
                                    },
                                    child: const Text('Pause'),
                                  ),
                                ),
                              if (isPaused)
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await ref
                                          .read(studyPlanServiceProvider)
                                          .resumePlan(plan.id);

                                      ref.invalidate(
                                        studyPlanDetailProvider(plan.id),
                                      );
                                      ref.invalidate(studyPlansProvider);
                                    },
                                    child: const Text('Resume'),
                                  ),
                                ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await ref
                                        .read(studyPlanServiceProvider)
                                        .cancelPlan(plan.id);

                                    ref.invalidate(
                                      studyPlanDetailProvider(plan.id),
                                    );
                                    ref.invalidate(studyPlansProvider);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ],
                          ),
                        ] else if (isCancelled) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'This plan has been cancelled.',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ] else if (isCompleted) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'This plan has been completed.',
                              style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ...plan.sessions.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    color: session.isCompleted
                                        ? AppColors.success.withOpacity(0.10)
                                        : AppColors.warning.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Session ${session.sequenceNumber}',
                                    style: TextStyle(
                                      color: session.isCompleted
                                          ? AppColors.success
                                          : AppColors.warning,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  session.isCompleted ? 'Completed' : 'Pending',
                                  style: TextStyle(
                                    color: session.isCompleted
                                        ? AppColors.success
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Scheduled: ${_formatDateTime(session.scheduledAtUtc)}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Planned Duration: ${session.plannedDurationMinutes} min',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (session.completedAtUtc != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Completed At: ${_formatDateTime(session.completedAtUtc!)}',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                            if (session.actualDurationMinutes != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Actual Duration: ${session.actualDurationMinutes} min',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                            if (session.intervalDays != null ||
                                session.repetitionCount != null ||
                                session.easinessFactor != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                children: [
                                  if (session.intervalDays != null)
                                    _MetaChip(
                                      label:
                                          'Interval: ${session.intervalDays} day',
                                    ),
                                  if (session.repetitionCount != null)
                                    _MetaChip(
                                      label:
                                          'Repeat: ${session.repetitionCount}',
                                    ),
                                  if (session.easinessFactor != null)
                                    _MetaChip(
                                      label:
                                          'EF: ${session.easinessFactor!.toStringAsFixed(2)}',
                                    ),
                                ],
                              ),
                            ],
                            if (session.notes != null &&
                                session.notes!.trim().isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                session.notes!,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Study Items',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (plan.items.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Text('No study items found.'),
                    ),
                  )
                else
                  ...plan.items.map(
                    (item) => _StudyPlanItemCard(item: item),
                  ),
              ],
            ),
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

class _DetailMiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _DetailMiniStat({
    required this.label,
    required this.value,
  });

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

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

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
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _StudyPlanItemCard extends StatelessWidget {
  final StudyPlanItemModel item;

  const _StudyPlanItemCard({
    required this.item,
  });

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
                CircleAvatar(
                  child: Text(item.orderNo.toString()),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.itemType,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (chunk != null) ...[
              Text(
                'Material Chunk',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                chunk.title ?? 'Chunk ${chunk.orderNo}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                chunk.content,
                maxLines: 3,
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