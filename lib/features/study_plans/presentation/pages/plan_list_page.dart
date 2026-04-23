import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../data/models/study_plan_model.dart';
import '../providers/study_plan_providers.dart';
import 'package:go_router/go_router.dart';

class PlanListPage extends ConsumerWidget {
  const PlanListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(studyPlansProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Plans'),
      ),
      body: plansAsync.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const _EmptyPlansState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(studyPlansProvider);
              await ref.read(studyPlansProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: plans.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final plan = plans[index];
          return _PlanCard(
  plan: plan,
  onTap: () {
    context.push('/plans/detail', extra: plan.id);
  },
);
              },
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

class _PlanCard extends StatelessWidget {
  final StudyPlanModel plan;
  final VoidCallback onTap;

  const _PlanCard({required this.plan,required this.onTap,});

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month.$year • $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final nextSession = plan.nextPendingSession;
    final progressPercent = (plan.progress * 100).round();

    return Card(
  child: InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: plan.isActive
                        ? AppColors.success.withOpacity(0.10)
                        : AppColors.warning.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    plan.status,
                    style: TextStyle(
                      color:
                          plan.isActive ? AppColors.success : AppColors.warning,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Start Date: ${plan.startDate}',
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Daily Target: ${plan.dailyTargetMinutes} min',
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _PlanMiniStat(
                    label: 'Total',
                    value: '${plan.totalSessions}',
                    icon: Icons.layers_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _PlanMiniStat(
                    label: 'Completed',
                    value: '${plan.completedSessions}',
                    icon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _PlanMiniStat(
                    label: 'Remaining',
                    value: '${plan.remainingSessions}',
                    icon: Icons.schedule_outlined,
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '$progressPercent%',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
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
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_note_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Next Session',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          nextSession != null
                              ? _formatDateTime(nextSession.scheduledAtUtc)
                              : 'No pending sessions',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  } 
}

class _PlanMiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PlanMiniStat({
    required this.label,
    required this.value,
    required this.icon,
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
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
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

class _EmptyPlansState extends StatelessWidget {
  const _EmptyPlansState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'No study plans yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Create a plan from a material to start generating sessions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}