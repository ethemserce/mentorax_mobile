import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_service.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authServiceProvider),
    ref.read(tokenStorageProvider),
  );
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(tokenStorageProvider));
});