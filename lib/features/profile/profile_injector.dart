import '../../core/di/init_dependencies.dart';
import '../../core/network/api_client.dart';
import '../../core/network/connection_checker.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/usecase/profile_usecase.dart';
import 'presentation/bloc/profile_bloc.dart';

class ProfileInjector {
  /// Initialize Profile feature dependencies
  static Future<void> init() async {
    // ── Data Source ──────────────────────────────────────────────────────
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteSourceImpl(
        apiClient: sl<ApiClient>(),
      ),
    );

    // ── Repository ───────────────────────────────────────────────────────
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteSource: sl<ProfileRemoteDataSource>(),
        connectionChecker: sl<ConnectionChecker>(),
      ),
    );

    // ── Use Cases ────────────────────────────────────────────────────────
    sl.registerLazySingleton(
      () => GetProfileUseCase(profileRepository: sl<ProfileRepository>()),
    );

    // ── BLoCs ────────────────────────────────────────────────────────────
    sl.registerFactory(
      () => ProfileBloc(profileUseCase: sl<GetProfileUseCase>()),
    );
  }
}
