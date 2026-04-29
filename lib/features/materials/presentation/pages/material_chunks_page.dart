import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentorax/core/state/app_refresh_controller.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../data/models/material_chunk_model.dart';
import '../providers/material_providers.dart';

class MaterialChunksPage extends ConsumerWidget {
  final String materialId;

  const MaterialChunksPage({
    super.key,
    required this.materialId,
  });

  Future<void> _moveChunk({
    required WidgetRef ref,
    required List<MaterialChunkModel> chunks,
    required int fromIndex,
    required int toIndex,
  }) async {
    final updated = [...chunks];

    final item = updated.removeAt(fromIndex);
    updated.insert(toIndex, item);

    await ref.read(materialServiceProvider).reorderMaterialChunks(
          materialId: materialId,
          chunkIds: updated.map((x) => x.id).toList(),
        );

ref
    .read(appRefreshControllerProvider)
    .refreshAfterChunkChanged(materialId);
  }

  Future<void> _deleteChunk({
    required BuildContext context,
    required WidgetRef ref,
    required String chunkId,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Chunk'),
          content: const Text(
            'Are you sure you want to delete this chunk? '
            'If this chunk is used in a study plan, it cannot be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref.read(materialServiceProvider).deleteMaterialChunk(
            materialId: materialId,
            chunkId: chunkId,
          );

ref
    .read(appRefreshControllerProvider)
    .refreshAfterChunkChanged(materialId);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chunk deleted')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chunksAsync = ref.watch(materialChunksProvider(materialId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Chunks'),
        actions: [
          IconButton(
            onPressed: () async {
              final created = await context.push(
                '/materials/chunks/create',
                extra: materialId,
              );

if (created == true) {
  ref
      .read(appRefreshControllerProvider)
      .refreshAfterChunkChanged(materialId);
}
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: chunksAsync.when(
        data: (chunks) {
          if (chunks.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(materialChunksProvider(materialId));
                await ref.read(materialChunksProvider(materialId).future);
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: const [
                  _EmptyChunksState(),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(materialChunksProvider(materialId));
              await ref.read(materialChunksProvider(materialId).future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: chunks.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final chunk = chunks[index];

                return _ChunkCard(
                  chunk: chunk,
                  index: index,
                  totalCount: chunks.length,
                  onTap: () async {
                    final updated = await context.push(
                      '/materials/chunks/detail',
                      extra: chunk,
                    );

if (updated == true) {
  ref
      .read(appRefreshControllerProvider)
      .refreshAfterChunkChanged(materialId);
}
                  },
                  onMoveUp: index == 0
                      ? null
                      : () => _moveChunk(
                            ref: ref,
                            chunks: chunks,
                            fromIndex: index,
                            toIndex: index - 1,
                          ),
                  onMoveDown: index == chunks.length - 1
                      ? null
                      : () => _moveChunk(
                            ref: ref,
                            chunks: chunks,
                            fromIndex: index,
                            toIndex: index + 1,
                          ),
                  onDelete: () => _deleteChunk(
                    context: context,
                    ref: ref,
                    chunkId: chunk.id,
                  ),
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

class _ChunkCard extends StatelessWidget {
  final MaterialChunkModel chunk;
  final int index;
  final int totalCount;
  final VoidCallback onTap;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback onDelete;

  const _ChunkCard({
    required this.chunk,
    required this.index,
    required this.totalCount,
    required this.onTap,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Part ${index + 1} of $totalCount',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'up') {
                        onMoveUp?.call();
                      } else if (value == 'down') {
                        onMoveDown?.call();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'up',
                        enabled: onMoveUp != null,
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_upward_outlined),
                            SizedBox(width: AppSpacing.sm),
                            Text('Move Up'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'down',
                        enabled: onMoveDown != null,
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_downward_outlined),
                            SizedBox(width: AppSpacing.sm),
                            Text('Move Down'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: AppColors.danger),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              'Delete',
                              style: TextStyle(color: AppColors.danger),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                chunk.content,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),

              if (chunk.summary != null && chunk.summary!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Summary: ${chunk.summary}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.md),

              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _MetaChip(
                    label: '${chunk.estimatedStudyMinutes} min',
                  ),
                  _MetaChip(
                    label: 'Difficulty ${chunk.difficultyLevel}',
                  ),
                  _MetaChip(
                    label: '${chunk.characterCount} chars',
                  ),
                  if (chunk.isGeneratedByAI)
                    const _MetaChip(
                      label: 'AI Generated',
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

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({
    required this.label,
  });

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
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyChunksState extends StatelessWidget {
  const _EmptyChunksState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'No chunks found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Use the + button to split this material into smaller study parts.',
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