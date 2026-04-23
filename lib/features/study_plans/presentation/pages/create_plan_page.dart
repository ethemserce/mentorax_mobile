import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/notifications/study_reminder_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/models/create_study_plan_request.dart';
import '../providers/study_plan_providers.dart';
import '../../../../core/state/app_refresh_controller.dart';

class CreatePlanPage extends ConsumerStatefulWidget {
  final String materialId;

  const CreatePlanPage({
    super.key,
    required this.materialId,
  });

  @override
  ConsumerState<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends ConsumerState<CreatePlanPage> {
  final _titleController = TextEditingController(text: 'Auto Plan');
  final _dailyTargetController = TextEditingController(text: '30');

  int _preferredHour = DateTime.now().hour;
  bool _isLoading = false;
  String? _generalError;

  @override
  void dispose() {
    _titleController.dispose();
    _dailyTargetController.dispose();
    super.dispose();
  }

  String _toDateOnlyString(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _createPlan() async {
    final title = _titleController.text.trim();
    final dailyTarget = int.tryParse(_dailyTargetController.text.trim());

    if (title.isEmpty || dailyTarget == null || dailyTarget <= 0) {
      setState(() {
        _generalError = 'Please fill required fields correctly.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      final request = CreateStudyPlanRequest(
        learningMaterialId: widget.materialId,
        title: title,
        startDate: _toDateOnlyString(DateTime.now()),
        dailyTargetMinutes: dailyTarget,
        preferredHour: _preferredHour,
        dayOffsets: const [0],
      );

      final createdPlan = await ref.read(studyPlanServiceProvider).createPlan(request);
      final detail = await ref.read(studyPlanServiceProvider).getPlanById(createdPlan.id);
      await StudyReminderService.instance.rescheduleFromPlanDetail(detail);

      if (!mounted) return;

      ref.read(appRefreshControllerProvider).refreshAfterPlanCreated();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan created')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _generalError = e.toString();
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
        title: const Text('Create Study Plan'),
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
                    'Schedule your study',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Create a study plan and let MentoraX generate your next session.',
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
            label: 'Plan Title',
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _dailyTargetController,
            label: 'Daily Target Minutes',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<int>(
            initialValue: _preferredHour,
            decoration: const InputDecoration(
              labelText: 'Preferred Hour',
            ),
            items: List.generate(
              24,
              (index) => DropdownMenuItem(
                value: index,
                child: Text('${index.toString().padLeft(2, '0')}:00'),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _preferredHour = value;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Your first session will be scheduled for today at the selected hour.',
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
            text: 'Create Plan',
            onPressed: _createPlan,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}