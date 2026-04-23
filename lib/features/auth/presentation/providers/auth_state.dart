enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final String? token;

  const AuthState({
    required this.status,
    this.token,
  });

  const AuthState.unknown()
      : status = AuthStatus.unknown,
        token = null;

  const AuthState.authenticated(String token)
      : status = AuthStatus.authenticated,
        token = token;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        token = null;
}