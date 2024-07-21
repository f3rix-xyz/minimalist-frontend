import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'clock_event.dart';
part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  ClockBloc() : super(ClockInitial()) {
    on<SetClockDuration>((event, emit) {
      emit(ClockDurationSet(event.duration));
    });
  }
}
