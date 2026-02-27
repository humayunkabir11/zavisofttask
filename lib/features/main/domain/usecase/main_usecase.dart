import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/main_repository.dart';
import '../../data/models/main_response.dart';


class MainUseCase implements UseCase<MainResponse, GetMainParams> {
  final MainRepository? mainRepository;
  MainUseCase({this.mainRepository});
  @override
  Future<Either<Failure, MainResponse>> call(GetMainParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }

}

class GetMainParams{
  final String? path;
  final Map<String, dynamic>? query;
  final Map<String, dynamic>? body;

  GetMainParams({
    this.path,
    this.query,
    this.body,
  });
}