import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/login_repository.dart';

class GetUserProfileParams {
  final int userId;
  const GetUserProfileParams(this.userId);
}

class GetUserProfileUseCase
    implements UseCase<UserEntity, GetUserProfileParams> {
  final LoginRepository repository;
  const GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(GetUserProfileParams params) =>
      repository.getUserProfile(params.userId);
}
