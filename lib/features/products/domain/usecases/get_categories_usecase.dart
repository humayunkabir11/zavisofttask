import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/product_repository.dart';

class GetCategoriesUseCase implements UseCase<List<String>, NoParams> {
  final ProductRepository repository;
  const GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) =>
      repository.getCategories();
}
