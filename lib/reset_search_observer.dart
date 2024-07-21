import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist/blocs/loadApp/app_bloc.dart';

class ResetSearchObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name == '/appScreen') {
      // Assuming '/appScreen' is the route name for your AppScreen
      route.navigator?.context.read<AppBloc>().add(ResetSearch());
    }
    super.didPop(route, previousRoute);
  }
}
