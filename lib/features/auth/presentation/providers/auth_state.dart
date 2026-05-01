enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? token;

  const AuthState({required this.status, this.token});

  const AuthState.unknown() : status = AuthStatus.unknown, token = null;

  const AuthState.authenticated(this.token) : status = AuthStatus.authenticated;

  const AuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      token = null;
}
