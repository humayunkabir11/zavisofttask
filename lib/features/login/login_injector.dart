import '../../core/di/init_dependencies.dart';
import '../../core/network/api_client.dart';
import '../../core/network/connection_checker.dart';
import '../../core/storage/secure_storage_service.dart';
import 'data/datasources/login_remote_data_source.dart';
import 'data/repositories/login_repository_impl.dart';
import 'domain/repositories/login_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/get_user_profile_usecase.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

class LoginInjector {
  /// Initialize Login feature dependencies
  static Future<void> init() async {
    // ── Data Source ──────────────────────────────────────────────────────
    sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(
        apiClient: sl<ApiClient>(),
      ),
    );

    // ── Repository ───────────────────────────────────────────────────────
    sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(
        remoteSource: sl<LoginRemoteDataSource>(),
        connectionChecker: sl<ConnectionChecker>(),
      ),
    );

    // ── Use Cases ────────────────────────────────────────────────────────
    sl.registerLazySingleton(
      () => LoginUseCase(sl<LoginRepository>()),
    );
    sl.registerLazySingleton(
      () => GetUserProfileUseCase(sl<LoginRepository>()),
    );

    // ── BLoCs (singleton = shared instance) ──────────────────────────
    sl.registerLazySingleton(
      () => AuthBloc(
        loginUseCase: sl(),
        getUserProfileUseCase: sl(),
        storage: sl<SecureStorageService>(),
      ),
    );
  }
}
