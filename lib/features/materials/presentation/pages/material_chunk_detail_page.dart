import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../data/models/material_chunk_model.dart';

class MaterialChunkDetailPage extends StatelessWidget {
  final MaterialChunkModel chunk;

  const MaterialChunkDetailPage({
    super.key,
    required this.chunk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chunk Detail'),
        actions: [
IconButton(
  onPressed: () async {
    final updated = await context.push('/materials/chunks/edit', extra: chunk);

    if (updated == true && context.mounted) {
      context.pop(true);
    }
  },
  icon: const Icon(Icons.edit_outlined),
),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
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
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${chunk.estimatedStudyMinutes} min • Difficulty ${chunk.difficultyLevel}',
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
                chunk.content,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  height: 1.6,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          if (chunk.summary != null && chunk.summary!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const _SectionTitle(title: 'Summary'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  chunk.summary!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],

          if (chunk.keywords != null && chunk.keywords!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const _SectionTitle(title: 'Keywords'),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: chunk.keywords!
                  .split(',')
                  .map((x) => x.trim())
                  .where((x) => x.isNotEmpty)
                  .map((keyword) => _KeywordChip(label: keyword))
                  .toList(),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metadata',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _MetaRow(label: 'Character Count', value: '${chunk.characterCount}'),
                  _MetaRow(label: 'AI Generated', value: chunk.isGeneratedByAI ? 'Yes' : 'No'),
                  _MetaRow(label: 'Learning Material Id', value: chunk.learningMaterialId),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

ElevatedButton.icon(
  onPressed: () async {
    final updated = await context.push('/materials/chunks/edit', extra: chunk);

    if (updated == true && context.mounted) {
      context.pop(true);
    }
  },
  icon: const Icon(Icons.edit_outlined),
  label: const Text('Edit Chunk'),
),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String label;

  const _KeywordChip({
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
        color: AppColors.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}