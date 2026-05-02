import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/token_storage.dart';
import 'auth_state.dart';

typedef SessionEndedCallback = Future<void> Function();

class AuthController extends StateNotifier<AuthState> {
  final TokenStorage _tokenStorage;
  final SessionEndedCallback? _onSessionEnded;

  AuthController(this._tokenStorage, {SessionEndedCallback? onSessionEnded})
    : _onSessionEnded = onSessionEnded,
      super(const AuthState.unknown());

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
    await _clearSession();
    state = const AuthState.unauthenticated();
  }

  Future<void> handleUnauthorized() async {
    await _clearSession();
    state = const AuthState.unauthenticated();
  }

  Future<void> _clearSession() async {
    await _tokenStorage.clearToken();
    await _onSessionEnded?.call();
  }
}
