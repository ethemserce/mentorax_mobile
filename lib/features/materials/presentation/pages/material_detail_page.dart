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
                            // ignore: deprecated_member_use
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

                if (material.description != null &&
                    material.description!.trim().isNotEmpty) ...[
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
                  const SizedBox(height: AppSpacing.lg),
                ],

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
                                // ignore: deprecated_member_use
                                ? AppColors.success.withOpacity(0.10)
                                // ignore: deprecated_member_use
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

                OutlinedButton.icon(
                  onPressed: () {
                    context.push('/plans', extra: material.id);
                  },
                  icon: const Icon(Icons.list_alt_outlined),
                  label: const Text('View Plans'),
                ),

                const SizedBox(height: AppSpacing.md),

                AppPrimaryButton(
                  text: material.hasActivePlan
                      ? 'Plan Already Exists'
                      : 'Create Study Plan',
                  onPressed: material.hasActivePlan
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