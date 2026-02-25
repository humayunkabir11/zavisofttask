import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteSource;
  final ConnectionChecker connectionChecker;

  LoginRepositoryImpl({
    required this.remoteSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, String>> login({
    required String username,
    required String password,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(message: "no internet connection!!"));
      }
      final result =
          await remoteSource.login(username: username, password: password);
      return right(result.token);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile(int userId) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(message: "no internet connection!!"));
      }
      final result = await remoteSource.getUserProfile(userId);
      return right(result.toEntity());
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: "Something went wrong"));
    }
  }
}
