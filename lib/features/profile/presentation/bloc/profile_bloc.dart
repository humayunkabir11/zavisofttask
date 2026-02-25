import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase profileUseCase;

  ProfileBloc({required this.profileUseCase}) : super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
  }

  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await profileUseCase(event.userId);
    result.fold(
      (failure) => emit(ProfileError(message: failure.message ?? 'Unknown Error')),
      (user) => emit(ProfileLoaded(user: user)),
    );
  }
}