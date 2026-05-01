import 'package:flutter/material.dart';
import 'package:mentorax/core/constants/app_colors.dart';
import 'package:mentorax/core/constants/app_spacing.dart';
import 'package:mentorax/core/sync/sync_status_model.dart';

class SyncStatusCard extends StatelessWidget {
  final SyncStatusModel status;
  final bool compact;
  final Future<void> Function()? onSyncNow;

  const SyncStatusCard({
    super.key,
    required this.status,
    this.compact = false,
    this.onSyncNow,
  });

  @override
  Widget build(BuildContext context) {
    final presentation = _presentationFor(status);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: presentation.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    presentation.icon,
                    color: presentation.color,
                    size: compact ? 20 : 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        presentation.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: compact ? 15 : 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _lastSyncText(status.lastSyncAt),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onSyncNow != null)
                  IconButton(
                    tooltip: 'Sync now',
                    onPressed: () async => onSyncNow?.call(),
                    icon: const Icon(Icons.sync),
                  ),
              ],
            ),
            if (!compact || !status.isSynced) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _StatusPill(
                    label: '${status.pendingCount} pending',
                    color: status.hasPending
                        ? AppColors.warning
                        : AppColors.textSecondary,
                  ),
                  _StatusPill(
                    label: '${status.conflictCount} conflicts',
                    color: status.hasConflicts
                        ? AppColors.danger
                        : AppColors.textSecondary,
                  ),
                  if (status.hasRetryScheduled)
                    _StatusPill(
                      label: '${status.retryScheduledCount} retrying later',
                      color: AppColors.warning,
                    ),
                ],
              ),
            ],
            if (!compact && status.lastError != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                status.lastError!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

_SyncStatusPresentation _presentationFor(SyncStatusModel status) {
  if (status.hasConflicts) {
    return const _SyncStatusPresentation(
      title: 'Sync needs review',
      color: AppColors.danger,
      icon: Icons.sync_problem,
    );
  }

  if (status.hasPending || status.hasRetryScheduled) {
    return const _SyncStatusPresentation(
      title: 'Sync pending',
      color: AppColors.warning,
      icon: Icons.cloud_sync_outlined,
    );
  }

  return const _SyncStatusPresentation(
    title: 'Synced',
    color: AppColors.success,
    icon: Icons.cloud_done_outlined,
  );
}

String _lastSyncText(DateTime? lastSyncAt) {
  if (lastSyncAt == null) return 'Last sync: Never';

  final local = lastSyncAt.toLocal();
  final date = _twoDigits(local.day);
  final month = _twoDigits(local.month);
  final hour = _twoDigits(local.hour);
  final minute = _twoDigits(local.minute);

  return 'Last sync: $date.$month.${local.year} $hour:$minute';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

class _SyncStatusPresentation {
  final String title;
  final Color color;
  final IconData icon;

  const _SyncStatusPresentation({
    required this.title,
    required this.color,
    required this.icon,
  });
}
