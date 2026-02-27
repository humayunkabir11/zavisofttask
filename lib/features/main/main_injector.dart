import '../../core/di/init_dependencies.dart';
import '../../core/network/api_client.dart';
import '../../core/network/connection_checker.dart';
import 'data/datasources/main_remote_data_source.dart';
import 'data/repositories/main_repository_impl.dart';
import 'domain/repositories/main_repository.dart';
import 'domain/usecase/main_usecase.dart';

import 'presentation/bloc/main_bloc.dart';

class MainInjector {
  /// Initialize Main feature dependencies
  static Future<void> init() async {
    sl.registerLazySingleton<MainRemoteDataSource>(
      () => MainRemoteSourceImpl(
        apiClient: sl<ApiClient>(), // Make sure ApiClient is already registered
      ),
    );

    sl.registerLazySingleton<MainRepository>(
      () => MainRepositoryImpl(
        remoteSource: sl<MainRemoteDataSource>(),
        connectionChecker: sl<ConnectionChecker>(),
      ),
    );

    sl.registerLazySingleton(
      () => MainUseCase(mainRepository: sl<MainRepository>()),
    );
    sl.registerFactory(() => MainBloc(mainUseCase: sl<MainUseCase>()));
  }
}
