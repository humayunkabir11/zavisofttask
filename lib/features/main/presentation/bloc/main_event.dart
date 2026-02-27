part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class FetchUser extends MainEvent {
  final String userId;
  const FetchUser(this.userId);

  @override
  List<Object> get props => [userId];
}