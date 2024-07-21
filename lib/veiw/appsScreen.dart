import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:minimalist/blocs/home/home_event.dart';
import '../blocs/loadApp/app_bloc.dart';
import '../blocs/home/home_bloc.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.pop(context);
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          context.read<AppBloc>().add(ResetSearch());
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: _SearchBar(),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.read<AppBloc>().add(ResetSearch());
                Navigator.pop(context);
              },
            ),
          ),
          body: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (state is AppLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is AppLoaded) {
                final apps = state.filteredApps ?? state.apps;
                return ListView.builder(
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return ListTile(
                      title: Text(
                        app.appName,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        DeviceApps.openApp(app.packageName);
                      },
                      onLongPress: () async {
                        var box = await Hive.openBox('myBox');
                        List<String> homeApps = List<String>.from(
                            box.get('homeApps', defaultValue: []));
                        if (!homeApps.contains(app.packageName)) {
                          context
                              .read<HomeBloc>()
                              .add(AddHomeApp(app.packageName));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${app.appName} added to home screen'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${app.appName} is already on the home screen'),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              } else if (state is AppError) {
                return Center(
                    child: Text('Failed to load apps',
                        style: TextStyle(color: Colors.red)));
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  __SearchBarState createState() => __SearchBarState();
}

class __SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search apps...',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {
            context.read<AppBloc>().add(SearchApps(_controller.text));
          },
        ),
      ),
      onChanged: (query) {
        context.read<AppBloc>().add(SearchApps(query));
      },
    );
  }
}
