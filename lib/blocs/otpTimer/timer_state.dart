import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class TimerInitial extends OtpState {}

class TimerRunInProgress extends OtpState {
  final int duration;

  const TimerRunInProgress(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerRunComplete extends OtpState {}
