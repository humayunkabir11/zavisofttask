import 'package:fpdart/src/either.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/repositories/main_repository.dart';
import '../../domain/usecase/main_usecase.dart';
import '../datasources/main_remote_data_source.dart';
import '../../../../core/common/models/success_response.dart';


class MainRepositoryImpl implements MainRepository {
  final MainRemoteDataSource remoteSource;
  final ConnectionChecker connectionChecker;

  MainRepositoryImpl(
      {required this.remoteSource, required this.connectionChecker});

  @override
  Future<Either<Failure, SuccessResponse?>> login(GetMainParams params) async {
    // TODO: implement login
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(message: "no internet connection!!"));
      } else {
        final data = await remoteSource.login(params);
        if (data?.success == false) {
          return left(
            Failure(
              message: data?.message ?? "Failed to login",
              statusCode: 0,
              constrain: data?.data?.code ?? "",
            )
          );
        } else {
          return right(data);
        }
      }
    } on ServerException catch (e) {
      return left(Failure(message:e.message));
    } catch (e) {
      return left(Failure(message: "Something went wrong"));
    }
  }
  
  
}
