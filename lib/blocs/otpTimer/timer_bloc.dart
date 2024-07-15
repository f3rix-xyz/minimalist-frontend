import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:minimalist/blocs/otpTimer/timer_event.dart';
import 'package:minimalist/blocs/otpTimer/timer_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  static const int _duration = 60;
  Timer? _timer;

  OtpBloc() : super(TimerInitial()) {
    on<StartTimer>((event, emit) => _onStartTimer(event, emit));
    on<Tick>((event, emit) => _onTick(event, emit));
  }

  void _onStartTimer(StartTimer event, Emitter<OtpState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      add(Tick());
    });
    emit(TimerRunInProgress(_duration));
  }

  void _onTick(Tick event, Emitter<OtpState> emit) {
    if (state is TimerRunInProgress) {
      final int duration = (state as TimerRunInProgress).duration - 1;
      if (duration > 0) {
        emit(TimerRunInProgress(duration));
      } else {
        _timer?.cancel();
        emit(TimerRunComplete());
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
