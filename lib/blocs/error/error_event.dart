part of 'error_bloc.dart';

abstract class ErrorEvent extends Equatable {
  const ErrorEvent();

  @override
  List<Object> get props => [];
}

class SetError extends ErrorEvent {
  final String message;

  const SetError(this.message);

  @override
  List<Object> get props => [message];
}

class ClearError extends ErrorEvent {}
