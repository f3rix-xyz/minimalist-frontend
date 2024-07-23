part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class LoadApps extends AppEvent {}

class SearchApps extends AppEvent {
  final String query;

  const SearchApps(this.query);

  @override
  List<Object> get props => [query];
}

class ResetSearch extends AppEvent {}

class AppUninstalled extends AppEvent {
  final Application app;

  AppUninstalled(this.app);
  @override
  List<Object> get props => [app];
}
