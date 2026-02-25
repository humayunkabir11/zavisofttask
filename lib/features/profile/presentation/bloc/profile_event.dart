part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  final int userId;
  const GetProfileEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}