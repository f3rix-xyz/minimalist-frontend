import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class StartTimer extends OtpEvent {}

class Tick extends OtpEvent {}
