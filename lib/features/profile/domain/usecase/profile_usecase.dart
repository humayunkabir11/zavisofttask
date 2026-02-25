import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase implements UseCase<ProfileUserEntity, int> {
  final ProfileRepository profileRepository;
  
  GetProfileUseCase({required this.profileRepository});
  
  @override
  Future<Either<Failure, ProfileUserEntity>> call(int userId) async {
    return await profileRepository.getUserProfile(userId);
  }
}