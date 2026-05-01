import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/state/app_refresh_controller.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../data/models/material_chunk_model.dart';
import '../../data/models/update_material_chunk_request.dart';
import '../providers/material_providers.dart';

class EditMaterialChunkPage extends ConsumerStatefulWidget {
  final MaterialChunkModel chunk;

  const EditMaterialChunkPage({super.key, required this.chunk});

  @override
  ConsumerState<EditMaterialChunkPage> createState() =>
      _EditMaterialChunkPageState();
}

class _EditMaterialChunkPageState extends ConsumerState<EditMaterialChunkPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _summaryController;
  late final TextEditingController _keywordsController;
  late final TextEditingController _difficultyController;
  late final TextEditingController _minutesController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.chunk.title ?? '');
    _contentController = TextEditingController(text: widget.chunk.content);
    _summaryController = TextEditingController(
      text: widget.chunk.summary ?? '',
    );
    _keywordsController = TextEditingController(
      text: widget.chunk.keywords ?? '',
    );
    _difficultyController = TextEditingController(
      text: widget.chunk.difficultyLevel.toString(),
    );
    _minutesController = TextEditingController(
      text: widget.chunk.estimatedStudyMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _summaryController.dispose();
    _keywordsController.dispose();
    _difficultyController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final difficulty = int.parse(_difficultyController.text.trim());
    final minutes = int.parse(_minutesController.text.trim());

    setState(() {
      _isSaving = true;
    });

    try {
      await ref
          .read(materialRepositoryProvider)
          .updateMaterialChunk(
            materialId: widget.chunk.learningMaterialId,
            chunkId: widget.chunk.id,
            request: UpdateMaterialChunkRequest(
              title: _titleController.text.trim().isEmpty
                  ? null
                  : _titleController.text.trim(),
              content: _contentController.text.trim(),
              summary: _summaryController.text.trim().isEmpty
                  ? null
                  : _summaryController.text.trim(),
              keywords: _keywordsController.text.trim().isEmpty
                  ? null
                  : _keywordsController.text.trim(),
              difficultyLevel: difficulty,
              estimatedStudyMinutes: minutes,
            ),
          );

      ref
          .read(appRefreshControllerProvider)
          .refreshAfterChunkChanged(widget.chunk.learningMaterialId);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Chunk updated')));

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Chunk')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Chunk Information',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _contentController,
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Content is required';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _summaryController,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Summary',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _keywordsController,
              decoration: const InputDecoration(
                labelText: 'Keywords',
                hintText: 'prepare, improve, habit',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _difficultyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Difficulty',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final number = int.tryParse(value ?? '');

                      if (number == null) {
                        return 'Required';
                      }

                      if (number < 1 || number > 5) {
                        return '1-5';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _minutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final number = int.tryParse(value ?? '');

                      if (number == null) {
                        return 'Required';
                      }

                      if (number <= 0) {
                        return '> 0';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            ElevatedButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_isSaving ? 'Saving...' : 'Save Chunk'),
            ),
          ],
        ),
      ),
    );
  }
}
