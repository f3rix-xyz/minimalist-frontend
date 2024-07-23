import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:device_apps/device_apps.dart';
import 'package:minimalist/veiw/appsScreen.dart';
import 'package:minimalist/veiw/auth/login_view.dart';
import 'package:minimalist/veiw/launcher.dart';
import 'package:minimalist/veiw/settingScreen.dart';
import 'package:minimalist/veiw/subscriptionScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../blocs/clock/clock_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isPressing = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    promptSetDefaultLauncher();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15), // Default duration
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onLongPressComplete();
      }
    });

    context.read<HomeBloc>().add(LoadHomeApps()); // Load home apps on init
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateBasedOnUser(String result) {
    if (result == "subscription") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SubscriptionScreen()),
      );
    } else if (result == "login") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _onLongPressComplete() {
    print("Long press completed");
    Navigator.push(
      context,
      _createPageRoute(),
    );
  }

  void _startLoading() {
    setState(() {
      isPressing = true;
    });
    _controller.forward(from: 0.0);
  }

  void _stopLoading() {
    setState(() {
      isPressing = false;
    });
    _controller.stop();
  }

  Future<void> _openContactsApp() async {
    bool isInstalled = await DeviceApps.isAppInstalled('com.android.contacts');

    if (isInstalled) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: 'content://contacts/people/',
      );
      await intent.launch();
    } else {
      const url = 'content://contacts/people/';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  Route _createPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AppScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Clock Widget
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTapDown: (_) {
                  _startLoading();
                },
                onTapUp: (_) {
                  _stopLoading();
                },
                onTapCancel: () {
                  _stopLoading();
                },
                child: Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    alignment: Alignment.center,
                    width:
                        isPressing ? 220 : 200, // Adjusted size for the clock
                    height:
                        isPressing ? 220 : 200, // Adjusted size for the clock
                    child: CustomPaint(
                      size: Size(200, 200), // Adjusted size for the clock
                      painter: ClockBorderPainter(_controller, isPressing),
                      child: Center(
                        child: BlocBuilder<ClockBloc, ClockState>(
                          builder: (context, state) {
                            if (state is ClockDurationSet) {
                              _controller.duration =
                                  Duration(seconds: state.duration);
                            }
                            return Text(
                              _getCurrentTime(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    isPressing ? 40 : 36, // Adjusted font size
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Contact Icon and Apps Widget
            Positioned(
              bottom: 150, // Adjusted position of the apps
              left: 20, // Added padding from the left
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return CircularProgressIndicator();
                  } else if (state is HomeLoaded) {
                    final homeApps = state.homeApps;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: _openContactsApp,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Contacts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24, // Increased font size
                              ),
                            ),
                          ),
                        ),
                        ...homeApps.map((packageName) {
                          return FutureBuilder<Application?>(
                            future: DeviceApps.getApp(packageName),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final app = snapshot.data;
                                return GestureDetector(
                                  onTap: () {
                                    DeviceApps.openApp(packageName);
                                  },
                                  onLongPress: () {
                                    context
                                        .read<HomeBloc>()
                                        .add(RemoveHomeApp(packageName));

                                    // Added SnackBar to show app removed message on long press
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${app!.appName} removed from home screen'),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      app!.appName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24, // Increased font size
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          );
                        }).toList(),
                      ],
                    );
                  } else if (state is HomeError) {
                    return Center(
                        child: Text('Failed to load home apps',
                            style: TextStyle(color: Colors.red)));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            // Settings Icon
            Positioned(
              top: 50,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentTime() {
    var now = DateTime.now();
    return DateFormat.Hm().format(now); // Hm formats hour and minute
  }
}

class ClockBorderPainter extends CustomPainter {
  final AnimationController controller;
  final bool isPressing;

  ClockBorderPainter(this.controller, this.isPressing)
      : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    if (isPressing) {
      double progress = controller.value * 2 * 3.141592653589793;
      // Draw the progress arc
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          -3.141592653589793 / 2, progress, false, paint);
    } else {
      // Draw the full border circle
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
