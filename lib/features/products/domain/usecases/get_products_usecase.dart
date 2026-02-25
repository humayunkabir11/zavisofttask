import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsParams {
  /// null → fetch all products; non-null → fetch by category
  final String? category;
  const GetProductsParams({this.category});
}

class GetProductsUseCase
    implements UseCase<List<Product>, GetProductsParams> {
  final ProductRepository repository;
  const GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
    GetProductsParams params,
  ) =>
      repository.getProducts(category: params.category);
}
