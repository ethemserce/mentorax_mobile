import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentorax/core/state/app_refresh_controller.dart';
import 'package:mentorax/features/progress/presentation/providers/progress_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/streak_milestones.dart';
import '../providers/dashboard_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    final progressAsync = ref.watch(progressSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MentoraX'),
        actions: [
          IconButton(
            onPressed: () async {
              final created = await context.push('/materials/create');

              if (created == true) {
                ref.read(appRefreshControllerProvider).refreshAfterMaterialCreated();
              }
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (dashboard) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardProvider);
              await ref.read(dashboardProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _HeroCard(
                  dueCount: dashboard.dueCount,
                  todayPlannedMinutes: dashboard.todayPlannedMinutes,
                  todayCompletedMinutes: dashboard.todayCompletedMinutes,
                  streakDays: progressAsync.value?.currentStreakDays ?? 0,
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Today Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        title: 'Planned',
                        value: '${dashboard.todayPlannedMinutes} min',
                        icon: Icons.schedule,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _InfoCard(
                        title: 'Completed',
                        value: '${dashboard.todayCompletedMinutes} min',
                        icon: Icons.check_circle_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Next Session',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (dashboard.nextSession == null)
                  const _EmptyStateCard(
                    title: 'No session available',
                    subtitle: 'Create a material and study plan to get started.',
                    icon: Icons.event_note_outlined,
                  )
                else
                  _NextSessionCard(
                    title: dashboard.nextSession!.materialTitle,
                    estimatedMinutes: dashboard.nextSession!.estimatedMinutes,
                    isDue: dashboard.nextSession!.isDue,
                    onTap: () {
                      context.go('/next-session');
                    },
                  ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Weak Materials',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (dashboard.weakMaterials.isEmpty)
                  const _EmptyStateCard(
                    title: 'No weak materials',
                    subtitle: 'Great job. Your weak material list is empty.',
                    icon: Icons.emoji_events_outlined,
                  )
                else
                  ...dashboard.weakMaterials.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _WeakMaterialCard(
                        title: item.title,
                        performanceLevel: item.performanceLevel,
                        nextReviewText: item.nextReviewAtUtc.toLocal().toString(),
                      ),
                    ),
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

class _HeroCard extends StatelessWidget {
  final int dueCount;
  final int todayPlannedMinutes;
  final int todayCompletedMinutes;
  final int streakDays;

  const _HeroCard({
    required this.dueCount,
    required this.todayPlannedMinutes,
    required this.todayCompletedMinutes,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final progress = todayPlannedMinutes == 0
        ? 0.0
        : (todayCompletedMinutes / todayPlannedMinutes).clamp(0.0, 1.0);

    final isMilestone = StreakMilestones.isMilestone(streakDays);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Keep going',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$dueCount session${dueCount == 1 ? '' : 's'} waiting today',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '$todayCompletedMinutes / $todayPlannedMinutes min completed',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '$streakDays day streak',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (isMilestone) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'Milestone reached',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
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
      ),
    );
  }
}

class _NextSessionCard extends StatelessWidget {
  final String title;
  final int estimatedMinutes;
  final bool isDue;
  final VoidCallback onTap;

  const _NextSessionCard({
    required this.title,
    required this.estimatedMinutes,
    required this.isDue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '$estimatedMinutes min • ${isDue ? "Due now" : "Upcoming"}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeakMaterialCard extends StatelessWidget {
  final String title;
  final String performanceLevel;
  final String nextReviewText;

  const _WeakMaterialCard({
    required this.title,
    required this.performanceLevel,
    required this.nextReviewText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$performanceLevel • Next review: $nextReviewText',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
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

class _EmptyStateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _EmptyStateCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}