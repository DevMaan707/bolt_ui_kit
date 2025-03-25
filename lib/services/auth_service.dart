import 'package:get/get.dart';
import '../api/api_service.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService;
  final StorageService _storageService;

  final RxBool isAuthenticated = false.obs;
  final Rx<String?> token = Rx<String?>(null);
  final Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});

  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService {
    _initFromStorage();
  }

  Future<void> _initFromStorage() async {
    final storedToken = _storageService.read<String>(_tokenKey);
    if (storedToken != null) {
      token.value = storedToken;
      isAuthenticated.value = true;

      final Map<String, dynamic>? storedUserData =
          _storageService.read<Map<String, dynamic>>(_userDataKey);
      if (storedUserData != null) {
        userData.value = storedUserData;
      }
    }
  }

  Future<bool> login({
    required String username,
    required String password,
    String endpoint = '/auth/login',
  }) async {
    final response = await _apiService.post(
      endpoint: endpoint,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.success && response.data != null) {
      final data = response.data;
      final String? authToken = data['token'];
      final Map<String, dynamic>? user = data['user'];

      if (authToken != null) {
        token.value = authToken;
        isAuthenticated.value = true;
        await _storageService.write(_tokenKey, authToken);

        if (user != null) {
          userData.value = user;
          await _storageService.write(_userDataKey, user);
        }

        return true;
      }
    }

    return false;
  }

  Future<bool> register({
    required Map<String, dynamic> userData,
    String endpoint = '/auth/register',
  }) async {
    final response = await _apiService.post(
      endpoint: endpoint,
      body: userData,
    );

    return response.success;
  }

  Future<void> logout() async {
    token.value = null;
    isAuthenticated.value = false;
    userData.value = {};

    await _storageService.remove(_tokenKey);
    await _storageService.remove(_userDataKey);
  }

  Future<bool> refreshToken({String endpoint = '/auth/refresh'}) async {
    if (token.value == null) return false;

    final response = await _apiService.post(
      endpoint: endpoint,
      headers: {'Authorization': 'Bearer ${token.value}'},
    );

    if (response.success && response.data != null) {
      final String? newToken = response.data['token'];
      if (newToken != null) {
        token.value = newToken;
        await _storageService.write(_tokenKey, newToken);
        return true;
      }
    }

    return false;
  }

  Map<String, String> get authHeaders {
    if (token.value != null) {
      return {'Authorization': 'Bearer ${token.value}'};
    }
    return {};
  }
}
