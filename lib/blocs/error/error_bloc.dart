// error_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'error_event.dart';
part 'error_state.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc() : super(ErrorInitial()) {
    on<SetError>(_onSetError);
    on<ClearError>(_onClearError);
  }

  void _onSetError(SetError event, Emitter<ErrorState> emit) {
    emit(ErrorMessage(event.message));
  }

  void _onClearError(ClearError event, Emitter<ErrorState> emit) {
    emit(ErrorInitial());
  }
}
