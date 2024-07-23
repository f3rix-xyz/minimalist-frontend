import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:android_intent/android_intent.dart';
import 'package:android_intent/flag.dart';
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
                      onLongPress: () {
                        _showOptions(context, app);
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

  void _showOptions(BuildContext context, Application app) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Add to home screen',
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  var box = await Hive.openBox('myBox');
                  List<String> homeApps =
                      List<String>.from(box.get('homeApps', defaultValue: []));
                  if (!homeApps.contains(app.packageName)) {
                    context.read<HomeBloc>().add(AddHomeApp(app.packageName));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('${app.appName} added to home screen')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${app.appName} is already on the home screen')),
                    );
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.white),
                title: Text('Uninstall', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _uninstallApp(context, app);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _uninstallApp(BuildContext context, Application app) {
    final packagename = app.packageName;
    final intent = AndroidIntent(
      action: 'android.intent.action.DELETE',
      data: Uri.encodeFull('package:$packagename'),
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch().then((_) {
      print("ok");
      context.read<AppBloc>().add(AppUninstalled(app));
      Navigator.pop(context); // Close the bottom sheet
    });
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
