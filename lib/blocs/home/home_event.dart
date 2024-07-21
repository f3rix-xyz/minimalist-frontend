import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeApps extends HomeEvent {}

class AddHomeApp extends HomeEvent {
  final String packageName;

  const AddHomeApp(this.packageName);

  @override
  List<Object> get props => [packageName];
}

class RemoveHomeApp extends HomeEvent {
  final String packageName;

  RemoveHomeApp(this.packageName);

  @override
  List<Object> get props => [packageName];
}
