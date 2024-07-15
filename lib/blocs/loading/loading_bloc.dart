// loading_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(LoadingInitial()) {
    on<StartLoading>(_onStartLoading);
    on<StopLoading>(_onStopLoading);
  }

  Future<void> _onStartLoading(
      StartLoading event, Emitter<LoadingState> emit) async {
    emit(LoadingInProgress());
  }

  Future<void> _onStopLoading(
      StopLoading event, Emitter<LoadingState> emit) async {
    emit(LoadingInitial());
  }
}
