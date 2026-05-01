import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentorax/core/notifications/study_reminder_service.dart';
import 'package:mentorax/core/state/app_refresh_controller.dart';
import 'package:mentorax/features/study_sessions/presentation/providers/session_timer_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../dashboard/data/models/next_session_model.dart';
import '../providers/study_session_providers.dart';
import 'package:go_router/go_router.dart';

class NextSessionPage extends ConsumerWidget {
  const NextSessionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextSessionAsync = ref.watch(nextSessionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Session'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/dashboard');
          },
        ),
      ),
      body: nextSessionAsync.when(
        data: (session) => _NextSessionView(session: session),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}

class _NextSessionView extends ConsumerStatefulWidget {
  final NextSessionModel session;

  const _NextSessionView({required this.session});

  @override
  ConsumerState<_NextSessionView> createState() => _NextSessionViewState();
}

class _NextSessionViewState extends ConsumerState<_NextSessionView> {
  bool _isStarting = false;

  Future<void> _startSession() async {
    if (widget.session.startedAtUtc != null) {
      context.push('/study-room', extra: widget.session.sessionId);
      return;
    }

    setState(() {
      _isStarting = true;
    });

    try {
      final started = await ref
          .read(sessionDashboardRepositoryProvider)
          .startSession(widget.session.sessionId);

      await StudyReminderService.instance.cancelForSession(started.sessionId);

      ref
          .read(sessionTimerProvider.notifier)
          .start(
            sessionId: started.sessionId,
            materialTitle: started.materialTitle,
          );

      // REFRESH
      ref
          .read(appRefreshControllerProvider)
          .refreshAfterSessionStarted(
            materialId: started.materialId,
            planId: started.studyPlanId,
          );

      if (!mounted) return;
      context.push('/study-room', extra: started.sessionId);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isStarting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your next learning step',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                session.materialTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  _SessionInfoChip(
                    icon: Icons.schedule,
                    label: '${session.estimatedMinutes} min',
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _SessionInfoChip(
                    icon: Icons.notifications_active_outlined,
                    label: session.isDue ? 'Due now' : 'Upcoming',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Session Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  title: 'Scheduled',
                  value: session.scheduledAtUtc.toLocal().toString(),
                ),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(
                  icon: Icons.play_circle_outline,
                  title: 'Started',
                  value: session.startedAtUtc != null
                      ? session.startedAtUtc!.toLocal().toString()
                      : 'Not started yet',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppPrimaryButton(
          text: session.startedAtUtc == null
              ? 'Start Session'
              : 'Continue Session',
          onPressed: _startSession,
          isLoading: _isStarting,
        ),
      ],
    );
  }
}

class _SessionInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SessionInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
