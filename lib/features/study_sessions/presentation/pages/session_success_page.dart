import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/streak_milestones.dart';
import '../../../../shared/widgets/app_primary_button.dart';

class SessionSuccessPage extends StatelessWidget {
  final int durationMinutes;
  final int qualityScore;
  final int streakDays;

  const SessionSuccessPage({
    super.key,
    required this.durationMinutes,
    required this.qualityScore,
    required this.streakDays,
  });

  String _getMessage() {
    if (qualityScore >= 4) {
      return 'Excellent work! Your recall is strong.';
    } else if (qualityScore >= 3) {
      return 'Good job! Keep reinforcing your memory.';
    } else {
      return 'Keep practicing. You will improve!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMilestone = StreakMilestones.isMilestone(streakDays);
    final milestoneTitle = StreakMilestones.getTitle(streakDays);
    final milestoneMessage = StreakMilestones.getMessage(streakDays);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Session Completed',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _getMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatBox(
                  label: 'Duration',
                  value: '$durationMinutes min',
                ),
                const SizedBox(width: AppSpacing.lg),
                _StatBox(
                  label: 'Score',
                  value: '$qualityScore / 5',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Current streak: $streakDays day${streakDays == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (isMilestone) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.workspace_premium,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      milestoneTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      milestoneMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              text: 'Back to Dashboard',
              onPressed: () {
                context.go('/dashboard');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}