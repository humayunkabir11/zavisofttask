import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/storage/secure_storage_service.dart';
import '../../../../../core/storage/secure_keys.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/get_user_profile_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// ------------------- Manages authentication: login → store token → fetch user profile.

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final SecureStorageService _storage;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required SecureStorageService storage,
  })  : _loginUseCase = loginUseCase,
        _getUserProfileUseCase = getUserProfileUseCase,
        _storage = storage,
        super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final loginResult = await _loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );

    await loginResult.fold(
      (failure) async => emit(AuthError(message: failure.message ?? 'Login failed')),
      (token) async {
        await _storage.write(SecureKeys.accessToken, token);

        final profileResult =
            await _getUserProfileUseCase(const GetUserProfileParams(1));

        profileResult.fold(
          (failure) => emit(AuthError(
              message: failure.message ?? 'Failed to load profile')),
          (user) => emit(AuthSuccess(user: user)),
        );
      },
    );
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) {
    _storage.deleteAll();
    emit(AuthInitial());
  }
}
