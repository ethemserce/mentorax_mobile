import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mentorax/features/auth/presentation/providers/auth_providers.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/app_primary_button.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Status: ${authState.status.name}',
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
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsInfoCard(
            icon: Icons.verified_user_outlined,
            title: 'Authentication Status',
            value: authState.status.name,
          ),
          const SizedBox(height: AppSpacing.md),
          _SettingsInfoCard(
            icon: Icons.key_outlined,
            title: 'Saved Token',
            value: authState.token != null && authState.token!.isNotEmpty
                ? 'Available'
                : 'Not available',
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Application',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Notification Test'),
                subtitle: const Text('Test instant and scheduled reminders'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.push('/settings/notification-test');
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Register Push Token'),
                  subtitle: const Text('Send device token to backend'),
                  onTap: () async {
                    // bunu bir sonraki adımda service/provider ile bağlayacağız
                  },
                ),
              ),
          const SizedBox(height: AppSpacing.md),
          _SettingsInfoCard(
            icon: Icons.language_outlined,
            title: 'API Base URL',
            value: AppConfig.baseUrl,
          ),
          const SizedBox(height: AppSpacing.md),
          const _SettingsInfoCard(
            icon: Icons.info_outline,
            title: 'Version',
            value: '0.1.0-dev',
          ),
          const SizedBox(height: AppSpacing.xl),
          AppPrimaryButton(
            text: 'Logout',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();

              if (!context.mounted) return;
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SettingsInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
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
            ),
          ],
        ),
      ),
    );
  }
}