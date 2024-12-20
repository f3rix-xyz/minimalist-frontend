import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalist/blocs/clock/clock_bloc.dart';
import 'package:minimalist/blocs/error/error_bloc.dart';
import 'package:minimalist/blocs/home/home_bloc.dart';
import 'package:minimalist/blocs/home/home_event.dart';
import 'package:minimalist/blocs/loadApp/app_bloc.dart';
import 'package:minimalist/blocs/loading/loading_bloc.dart';
import 'package:minimalist/blocs/otpTimer/timer_bloc.dart';
import 'package:minimalist/data/api.dart';
import 'package:minimalist/repository/checkuser_repository.dart';

import 'package:minimalist/reset_search_observer.dart';
import 'package:minimalist/veiw/homeScreen.dart';
import 'package:minimalist/veiw/subscriptionScreen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => userData(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppBloc()..add(LoadApps())),
          BlocProvider(create: (context) => ErrorBloc()..add(ClearError())),
          BlocProvider(create: (context) => OtpBloc()),
          BlocProvider(create: (context) => LoadingBloc()),
          BlocProvider(create: (context) => HomeBloc()..add(LoadHomeApps())),
          BlocProvider(
              create: (context) => ClockBloc()..add(SetClockDuration(10))),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          navigatorObservers: [ResetSearchObserver()],
          home: FutureBuilder(
            future: checkUser(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data == "home") {
                return HomeScreen(); // Navigate to home screen if user is fetched successfully
              } else if (snapshot.hasData && snapshot.data == "subscription") {
                return SubscriptionScreen(); // Navigate to subscription screen if user subscription is expired
              } else {
                return HomeScreen(); // Navigate to login screen if user fetch fails
              }
            },
          ),
        ),
      ),
    );
  }
}
