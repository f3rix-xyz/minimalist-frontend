import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist/blocs/loadApp/app_bloc.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(LoadApps()),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: _SearchBar(),
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
