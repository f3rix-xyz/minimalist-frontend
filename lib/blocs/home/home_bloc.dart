import 'package:bloc/bloc.dart';

import 'package:hive/hive.dart';
import 'package:minimalist/blocs/home/home_event.dart';
import 'package:minimalist/blocs/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeApps>(_onLoadHomeApps);
    on<AddHomeApp>(_onAddHomeApp);
    on<RemoveHomeApp>(_onRemoveHomeApp);
  }

  Future<void> _onLoadHomeApps(
      LoadHomeApps event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      var box = await Hive.openBox('myBox');
      List<String> homeApps =
          List<String>.from(box.get('homeApps', defaultValue: []));
      print("Home apps loading apps : $homeApps");
      emit(HomeLoaded(homeApps: homeApps));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onAddHomeApp(AddHomeApp event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      var box = await Hive.openBox('myBox');
      List<String> homeApps =
          List<String>.from(box.get('homeApps', defaultValue: []));

      if (!homeApps.contains(event.packageName)) {
        homeApps.add(event.packageName);

        await box.put('homeApps', homeApps);

        emit(HomeLoaded(homeApps: homeApps));
      }
    }
  }

  Future<void> _onRemoveHomeApp(
      RemoveHomeApp event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      var box = await Hive.openBox('myBox');
      List<String> homeApps =
          List<String>.from(box.get('homeApps', defaultValue: []));

      if (homeApps.contains(event.packageName)) {
        homeApps.remove(event.packageName);

        await box.put('homeApps', homeApps);
        emit(HomeLoaded(homeApps: homeApps));
      }
    }
  }
}
