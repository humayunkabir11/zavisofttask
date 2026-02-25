import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

/// FakeStore base URL — all endpoints are relative to this.
const _kBase = 'https://fakestoreapi.com';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  });
  Future<UserModel> getUserProfile(int userId);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiClient apiClient;

  LoginRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final result = await apiClient.post(
        api: '$_kBase/auth/login',
        body: {'username': username, 'password': password},
      );
      return LoginResponseModel.fromJson(
        result.data as Map<String, dynamic>,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserProfile(int userId) async {
    try {
      final result = await apiClient.get(
        api: '$_kBase/users/$userId',
      );
      return UserModel.fromJson(
        result.data as Map<String, dynamic>,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
