part of 'clock_bloc.dart';

abstract class ClockState extends Equatable {
  const ClockState();

  @override
  List<Object> get props => [];
}

class ClockInitial extends ClockState {}

class ClockDurationSet extends ClockState {
  final int duration;

  const ClockDurationSet(this.duration);

  @override
  List<Object> get props => [duration];
}
