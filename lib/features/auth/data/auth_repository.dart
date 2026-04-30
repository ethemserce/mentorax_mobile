import '../../../core/storage/token_storage.dart';
import 'auth_response_model.dart';
import 'auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  final TokenStorage _tokenStorage;

  AuthRepository(this._authService, this._tokenStorage);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(
      email: email,
      password: password,
    );

    await _tokenStorage.saveTokens(
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    );
    return result;
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final result = await _authService.register(
      fullName: fullName,
      email: email,
      password: password,
    );

    await _tokenStorage.saveToken(result.accessToken);
    return result;
  }
  
  Future<String?> getSavedToken() async {
  return _tokenStorage.getToken();
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
  }
  
}