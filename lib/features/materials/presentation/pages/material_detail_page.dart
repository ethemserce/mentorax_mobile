import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/state/app_refresh_controller.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../providers/material_providers.dart';

class MaterialDetailPage extends ConsumerWidget {
  final String materialId;

  const MaterialDetailPage({
    super.key,
    required this.materialId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialAsync = ref.watch(materialDetailProvider(materialId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Detail'),
      ),
      body: materialAsync.when(
        data: (material) {
          final tags = (material.tags ?? '')
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(materialDetailProvider(materialId));
              ref.invalidate(materialListProvider);
              await ref.read(materialDetailProvider(materialId).future);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.menu_book_outlined,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                material.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '${material.materialType} • ${material.estimatedDurationMinutes} min',
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
                ),

                const SizedBox(height: AppSpacing.lg),

                _ActionPanel(
                  hasActivePlan: material.hasActivePlan,
                  activePlanTitle: material.activePlanTitle,
                  onViewPlan: () {
                    if (material.hasActivePlan &&
                        material.activePlanId != null) {
                      context.push(
                        '/plans/detail',
                        extra: material.activePlanId,
                      );
                      return;
                    }

                    context.push('/plans', extra: material.id);
                  },
                  onViewChunks: () {
                    context.push('/materials/chunks', extra: material.id);
                  },
                  onCreatePlan: material.hasActivePlan
                      ? null
                      : () async {
                          final created = await context.push(
                            '/plans/create',
                            extra: material.id,
                          );

                          if (created == true) {
                            ref.invalidate(materialDetailProvider(materialId));
                            ref.invalidate(materialListProvider);
                            ref
                                .read(appRefreshControllerProvider)
                                .refreshAfterPlanCreated();

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Plan created for this material'),
                              ),
                            );
                          }
                        },
                ),

                const SizedBox(height: AppSpacing.lg),

                const _SectionTitle(title: 'Plan Status'),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: material.hasActivePlan
                                ? AppColors.success.withOpacity(0.10)
                                : AppColors.warning.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            material.hasActivePlan
                                ? Icons.check_circle_outline
                                : Icons.schedule,
                            color: material.hasActivePlan
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                material.hasActivePlan
                                    ? 'Active plan available'
                                    : 'No active plan',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                material.hasActivePlan
                                    ? (material.activePlanTitle ??
                                        'This material already has an active plan.')
                                    : 'Create a study plan to generate sessions for this material.',
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
                ),

                const SizedBox(height: AppSpacing.lg),

                const _SectionTitle(title: 'Content'),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      material.content,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                if (material.description != null &&
                    material.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionTitle(title: 'Description'),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        material.description!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],

                if (tags.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionTitle(title: 'Tags'),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: tags.map((tag) => _TagChip(label: tag)).toList(),
                  ),
                ],

                const SizedBox(height: AppSpacing.xl),
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

class _ActionPanel extends StatelessWidget {
  final bool hasActivePlan;
  final String? activePlanTitle;
  final VoidCallback onViewPlan;
  final VoidCallback onViewChunks;
  final VoidCallback? onCreatePlan;

  const _ActionPanel({
    required this.hasActivePlan,
    required this.activePlanTitle,
    required this.onViewPlan,
    required this.onViewChunks,
    required this.onCreatePlan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              hasActivePlan
                  ? 'Continue with your active plan or review chunks.'
                  : 'Create a plan or review material chunks first.',
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            if (hasActivePlan && activePlanTitle != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.18),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        activePlanTitle!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewPlan,
                    icon: const Icon(Icons.list_alt_outlined),
                    label: Text(hasActivePlan ? 'View Plan' : 'View Plans'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewChunks,
                    icon: const Icon(Icons.account_tree_outlined),
                    label: const Text('View Chunks'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AppPrimaryButton(
                text: hasActivePlan ? 'Plan Already Exists' : 'Create Study Plan',
                onPressed: onCreatePlan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

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