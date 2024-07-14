import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minimalist/blocs/loadApp/app_bloc.dart';
import 'package:minimalist/repository/user_repository.dart';
import 'package:minimalist/veiw/auth/login.dart';
import 'package:minimalist/veiw/homeScreen.dart';

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
      create: (context) => UserRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppBloc()..add(LoadApps()))
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: FutureBuilder(
            future: _checkUser(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data == true) {
                return HomeScreen(); // Navigate to home screen if user is fetched successfully
              } else {
                return LoginScreen(); // Navigate to login screen if user fetch fails
              }
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _checkUser(BuildContext context) async {
    var userRepository = RepositoryProvider.of<UserRepository>(context);
    try {
      var user = await userRepository.fetchUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
