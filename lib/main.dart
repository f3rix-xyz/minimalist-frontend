import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalist/blocs/error/error_bloc.dart';
import 'package:minimalist/blocs/loadApp/app_bloc.dart';
import 'package:minimalist/blocs/otpTimer/timer_bloc.dart';
import 'package:minimalist/data/api.dart';
import 'package:minimalist/repository/checkuser_repository.dart';
import 'package:minimalist/repository/user_repository.dart';
import 'package:minimalist/veiw/auth/login_view.dart';
import 'package:minimalist/veiw/homeScreen.dart';
import 'package:minimalist/veiw/subscriptionScreen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => userData(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppBloc()..add(LoadApps())),
          BlocProvider(create: (context) => ErrorBloc()..add(ClearError())),
          BlocProvider(create: (context) => OtpBloc()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
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
                return LoginScreen(); // Navigate to login screen if user fetch fails
              }
            },
          ),
        ),
      ),
    );
  }
}
