import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/models/create_material_request_model.dart';
import '../providers/material_providers.dart';
import '../../../../core/state/app_refresh_controller.dart';

class CreateMaterialPage extends ConsumerStatefulWidget {
  const CreateMaterialPage({super.key});

  @override
  ConsumerState<CreateMaterialPage> createState() => _CreateMaterialPageState();
}

class _CreateMaterialPageState extends ConsumerState<CreateMaterialPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _durationController = TextEditingController(text: '20');
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  String _materialType = 'Text';
  bool _isLoading = false;
  String? _generalError;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _createMaterial() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final duration = int.tryParse(_durationController.text.trim());

    if (title.isEmpty || content.isEmpty || duration == null || duration <= 0) {
      setState(() {
        _generalError = 'Please fill all required fields correctly.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      final request = CreateMaterialRequestModel(
        title: title,
        materialType: _materialType,
        content: content,
        estimatedDurationMinutes: duration,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        tags: _tagsController.text.trim().isEmpty
            ? null
            : _tagsController.text.trim(),
      );

      final result = await ref.read(materialRepositoryProvider).createMaterial(request);

      if (!mounted) return;

      ref.read(appRefreshControllerProvider).refreshAfterMaterialCreated();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Material created: ${result.title}')),
      );

      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      setState(() {
        _generalError = e.message;
      });
    } catch (_) {
      setState(() {
        _generalError = 'Unexpected error occurred.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Material'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Create learning content',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Add a material that you want to study repeatedly with MentoraX.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: _titleController,
            label: 'Title *',
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _materialType,
            decoration: const InputDecoration(
              labelText: 'Material Type',
            ),
            items: const [
              DropdownMenuItem(value: 'Text', child: Text('Text')),
              DropdownMenuItem(value: 'Document', child: Text('Document')),
              DropdownMenuItem(value: 'Video', child: Text('Video')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _materialType = value;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _contentController,
            label: 'Content *',
            maxLines: 6,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _durationController,
            label: 'Estimated Duration (minutes) *',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _descriptionController,
            label: 'Description',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _tagsController,
            label: 'Tags',
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Example: english,vocabulary,work',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_generalError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                _generalError!,
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            text: 'Create Material',
            onPressed: _createMaterial,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}