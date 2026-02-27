import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecase/main_usecase.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final MainUseCase mainUseCase;
  MainBloc({required this.mainUseCase}) : super(MainInitial());

  Stream<MainState> mapEventToState(MainEvent event) async* {
    // if (event is FetchUser) {
    //   yield UserLoading();
    //   try {
    //     final user = await getUserUseCase(event.userId);
    //     yield UserLoaded(user);
    //   } catch (e) {
    //     yield UserError(e.toString());
    //   }
    // }
  }
}