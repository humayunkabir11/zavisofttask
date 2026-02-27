import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../usecase/main_usecase.dart';
import '../../../../core/common/models/success_response.dart';

abstract class MainRepository {
  Future<Either<Failure, SuccessResponse?>> login(GetMainParams params);
}
