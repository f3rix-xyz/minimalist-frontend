part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final List<Application> apps;
  final List<Application>? filteredApps;

  const AppLoaded({required this.apps, this.filteredApps});

  @override
  List<Object> get props => [apps, filteredApps ?? []];
}

class AppError extends AppState {
  final String? message;

  const AppError(this.message);

  @override
  List<Object> get props => [message ?? ''];
}
