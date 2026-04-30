import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/token_storage.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  final TokenStorage _tokenStorage;

  AuthController(this._tokenStorage) : super(const AuthState.unknown());

  Future<void> checkAuthStatus() async {
    final token = await _tokenStorage.getToken();

    if (token != null && token.isNotEmpty) {
      state = AuthState.authenticated(token);
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> setAuthenticated(String token) async {
    await _tokenStorage.saveToken(token);
    state = AuthState.authenticated(token);
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
    state = const AuthState.unauthenticated();
  }
  
}