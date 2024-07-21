part of 'clock_bloc.dart';

abstract class ClockEvent extends Equatable {
  const ClockEvent();

  @override
  List<Object> get props => [];
}

class SetClockDuration extends ClockEvent {
  final int duration;

  const SetClockDuration(this.duration);

  @override
  List<Object> get props => [duration];
}
