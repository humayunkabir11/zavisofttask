import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileUserEntity>> getUserProfile(int userId);
}
