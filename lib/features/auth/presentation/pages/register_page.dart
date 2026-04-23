import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/app_primary_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_providers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _generalError;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _fullNameError = null;
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    var isValid = true;

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (fullName.isEmpty) {
      _fullNameError = 'Full name is required';
      isValid = false;
    }

    if (email.isEmpty) {
      _emailError = 'Email is required';
      isValid = false;
    } else if (!email.contains('@')) {
      _emailError = 'Enter a valid email';
      isValid = false;
    }

    if (password.isEmpty) {
      _passwordError = 'Password is required';
      isValid = false;
    } else if (password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  Future<void> _onRegisterPressed() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    try {
      final result = await ref.read(authRepositoryProvider).register(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await ref
          .read(authControllerProvider.notifier)
          .setAuthenticated(result.token);

      if (!mounted) return;
      context.go('/dashboard');
    } on ApiException catch (e) {
      setState(() {
        _generalError = e.message;
      });
    } catch (_) {
      setState(() {
        _generalError = 'Unexpected error occurred';
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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                'Create account',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Start building your smart learning routine.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                controller: _fullNameController,
                label: 'Full Name',
                errorText: _fullNameError,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                errorText: _passwordError,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (_generalError != null)
                Text(
                  _generalError!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                text: 'Register',
                onPressed: _onRegisterPressed,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Already have an account? Login'),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}