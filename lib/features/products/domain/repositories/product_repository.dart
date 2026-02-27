import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

/// Contract for product data operations.
abstract interface class ProductRepository {
  /// Fetches all products. If [category] is provided, filters by category.
  Future<Either<Failure, List<Product>>> getProducts({String? category});

  /// Fetches all product categories.
  Future<Either<Failure, List<String>>> getCategories();
}
