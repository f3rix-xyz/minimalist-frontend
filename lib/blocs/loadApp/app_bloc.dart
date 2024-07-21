import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:device_apps/device_apps.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<LoadApps>(_onLoadApps);
    on<SearchApps>(_onSearchApps);
    on<ResetSearch>(_onResetSearch);
  }

  void _onLoadApps(LoadApps event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      final apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
      );
      apps.sort(
          (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      emit(AppLoaded(apps: apps));
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  void _onSearchApps(SearchApps event, Emitter<AppState> emit) {
    if (state is AppLoaded) {
      final apps = (state as AppLoaded).apps;
      final filteredApps = apps
          .where((app) =>
              app.appName.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(AppLoaded(apps: apps, filteredApps: filteredApps));
    }
  }

  void _onResetSearch(ResetSearch event, Emitter<AppState> emit) {
    if (state is AppLoaded) {
      final apps = (state as AppLoaded).apps;
      emit(AppLoaded(apps: apps));
    }
  }
}
