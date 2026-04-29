import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentorax/shared/widgets/app_empty_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/state/app_refresh_controller.dart';
import '../../data/models/material_model.dart';
import '../providers/material_providers.dart';

class MaterialListPage extends ConsumerStatefulWidget {
  const MaterialListPage({super.key});

  @override
  ConsumerState<MaterialListPage> createState() => _MaterialListPageState();
}

class _MaterialListPageState extends ConsumerState<MaterialListPage> {
  final _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MaterialModel> _filterMaterials(List<MaterialModel> materials) {
    if (_searchText.trim().isEmpty) {
      return materials;
    }

    final query = _searchText.trim().toLowerCase();

    return materials.where((material) {
      final title = material.title.toLowerCase();
      final type = material.materialType.toLowerCase();
      final description = (material.description ?? '').toLowerCase();
      final tags = (material.tags ?? '').toLowerCase();
      final content = material.content.toLowerCase();

      return title.contains(query) ||
          type.contains(query) ||
          description.contains(query) ||
          tags.contains(query) ||
          content.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final materialsAsync = ref.watch(materialListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materials'),
        actions: [
          IconButton(
            onPressed: () async {
              final created = await context.push('/materials/create');

              if (created == true) {
                ref.read(appRefreshControllerProvider).refreshAfterMaterialCreated();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: materialsAsync.when(
        data: (materials) {
          if (materials.isEmpty) {
            return const _EmptyMaterialsState();
          }

          final filteredMaterials = _filterMaterials(materials);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(materialListProvider);
              await ref.read(materialListProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search materials, tags, content...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchText = '';
                              });
                            },
                            icon: const Icon(Icons.close),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (filteredMaterials.isEmpty)
                  const _NoSearchResultState()
                else
                  ...filteredMaterials.map(
                    (material) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _MaterialCard(
  title: material.title,
  materialType: material.materialType,
  duration: material.estimatedDurationMinutes,
  description: material.description,
  tags: material.tags,
  hasActivePlan: material.hasActivePlan,
  activePlanTitle: material.activePlanTitle,
  onTap: () async {
    await context.push(
      '/materials/detail',
      extra: material.id,
    );
  },
  onCreatePlan: () async {
    final created = await context.push(
      '/plans/create',
      extra: material.id,
    );

    if (created == true) {
      ref.read(appRefreshControllerProvider).refreshAfterPlanCreated();
    }
  },
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

class _MaterialCard extends StatelessWidget {
  final String title;
  final String materialType;
  final int duration;
  final String? description;
  final String? tags;
  final VoidCallback onTap;
  final VoidCallback onCreatePlan;
  final bool hasActivePlan;
  final String? activePlanTitle;

  const _MaterialCard({
    required this.title,
    required this.materialType,
    required this.duration,
    required this.description,
    required this.tags,
    required this.onTap,
    required this.onCreatePlan,
    required this.hasActivePlan,
    required this.activePlanTitle,
  });

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: AppColors.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.menu_book_outlined,
                      color: AppColors.primary,
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
                          '$materialType • $duration min',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              if (description != null && description!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  description!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.sm,
  ),
  decoration: BoxDecoration(
    color: hasActivePlan
        // ignore: deprecated_member_use
        ? AppColors.success.withOpacity(0.10)
        // ignore: deprecated_member_use
        : AppColors.warning.withOpacity(0.10),
    borderRadius: BorderRadius.circular(999),
  ),
  child: Text(
    hasActivePlan
        ? 'Active Plan: ${activePlanTitle ?? "Available"}'
        : 'No active plan',
    style: TextStyle(
      color: hasActivePlan ? AppColors.success : AppColors.warning,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),
  ),
),
              if (tags != null && tags!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: tags!
                      .split(',')
                      .map((tag) => _TagChip(label: tag.trim()))
                      .toList(),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                 Expanded(
  child: OutlinedButton.icon(
    onPressed: hasActivePlan ? null : onCreatePlan,
    icon: const Icon(Icons.auto_awesome),
    label: Text(hasActivePlan ? 'Plan Available' : 'Create Plan'),
  ),
),
                ],
              ),
            ],
          ),
        ),
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

class _EmptyMaterialsState extends StatelessWidget {
  const _EmptyMaterialsState();

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.menu_book_outlined,
      title: 'No materials yet',
      subtitle: 'Create your first learning material to start building study plans.',
      actionText: 'Create Material',
      onAction: () {
        context.push('/materials/create');
      },
    );
  }
}

class _NoSearchResultState extends StatelessWidget {
  const _NoSearchResultState();

  @override
  Widget build(BuildContext context) {
    return const AppEmptyState(
      icon: Icons.search_off_outlined,
      title: 'No matching materials found',
      subtitle: 'Try a different keyword, tag, or content phrase.',
    );
  }
}