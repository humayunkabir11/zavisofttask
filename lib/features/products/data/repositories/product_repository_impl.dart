import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/server_exception.dart';
import '../../../../core/network/connection_checker.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteSource;
  final ConnectionChecker connectionChecker;

  ProductRepositoryImpl({
    required this.remoteSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? category,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(message: "no internet connection!!"));
      }
      final result = await remoteSource.getProducts(category: category);
      return right(result.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    } catch (e) {
      return left(Failure(message: "Something went wrong"));
    }
  }
}
