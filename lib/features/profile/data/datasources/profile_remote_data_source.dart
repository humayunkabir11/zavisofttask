import '../../../../core/config/strings/api_endpoint.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';


abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile(int userId);
}

class ProfileRemoteSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteSourceImpl({required this.apiClient});

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
