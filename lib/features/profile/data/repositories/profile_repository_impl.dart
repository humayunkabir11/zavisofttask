import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteSource;
  final ConnectionChecker connectionChecker;

  ProfileRepositoryImpl({
    required this.remoteSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, ProfileUserEntity>> getUserProfile(int userId) async {
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
