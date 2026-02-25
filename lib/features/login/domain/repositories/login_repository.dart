import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Contract for login-related data operations.
abstract interface class LoginRepository {
  /// Authenticates with FakeStore API and returns a JWT token.
  Future<Either<Failure, String>> login({
    required String username,
    required String password,
  });

  /// Fetches a user profile by ID.
  Future<Either<Failure, UserEntity>> getUserProfile(int userId);
}
