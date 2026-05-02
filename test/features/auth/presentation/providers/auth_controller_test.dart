import 'package:flutter_test/flutter_test.dart';
import 'package:mentorax/core/storage/token_storage.dart';
import 'package:mentorax/features/auth/presentation/providers/auth_controller.dart';
import 'package:mentorax/features/auth/presentation/providers/auth_state.dart';

void main() {
  test('logout clears tokens and local session data', () async {
    var resetCount = 0;
    final tokenStorage = _FakeTokenStorage(accessToken: 'access-token');
    final controller = AuthController(
      tokenStorage,
      onSessionEnded: () async {
        resetCount += 1;
      },
    );

    await controller.checkAuthStatus();
    await controller.logout();

    expect(controller.state.status, AuthStatus.unauthenticated);
    expect(await tokenStorage.getToken(), isNull);
    expect(resetCount, 1);
  });

  test('unauthorized handling clears tokens and local session data', () async {
    var resetCount = 0;
    final tokenStorage = _FakeTokenStorage(accessToken: 'access-token');
    final controller = AuthController(
      tokenStorage,
      onSessionEnded: () async {
        resetCount += 1;
      },
    );

    await controller.handleUnauthorized();

    expect(controller.state.status, AuthStatus.unauthenticated);
    expect(await tokenStorage.getToken(), isNull);
    expect(resetCount, 1);
  });
}

class _FakeTokenStorage extends TokenStorage {
  String? accessToken;
  String? refreshToken;

  _FakeTokenStorage({this.accessToken});

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> saveToken(String token) async {
    accessToken = token;
  }

  @override
  Future<String?> getAccessToken() async {
    return accessToken;
  }

  @override
  Future<String?> getRefreshToken() async {
    return refreshToken;
  }

  @override
  Future<String?> getToken() async {
    return accessToken;
  }

  @override
  Future<void> clearTokens() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<void> clearToken() async {
    await clearTokens();
  }
}
