import 'package:zavi_soft_task/core/config/strings/api_endpoint.dart';

import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';


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
        api: ApiEndpoint.login,
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
        api: '${ApiEndpoint.users}/$userId',
      );
      return UserModel.fromJson(
        result.data as Map<String, dynamic>,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
