import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> homeApps;

  const HomeLoaded({required this.homeApps});

  @override
  List<Object> get props => [homeApps];
}

class HomeError extends HomeState {
  final String? message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message ?? ''];
}
