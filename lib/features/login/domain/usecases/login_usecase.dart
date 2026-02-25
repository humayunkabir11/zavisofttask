import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/login_repository.dart';

class LoginParams {
  final String username;
  final String password;
  const LoginParams({required this.username, required this.password});
}

class LoginUseCase implements UseCase<String, LoginParams> {
  final LoginRepository repository;
  const LoginUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginParams params) =>
      repository.login(username: params.username, password: params.password);
}
