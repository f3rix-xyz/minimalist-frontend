import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isPressing = false;
  late AnimationController _controller;
  final int loadingDuration = 10; // Adjust this value to control the speed

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: loadingDuration), // Set the duration here
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onLongPressComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLongPressComplete() {
    print("Long press completed after $loadingDuration seconds");
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
    // Check if the contacts app is installed (usually, it is by default)
    bool isInstalled = await DeviceApps.isAppInstalled('com.android.contacts');

    if (isInstalled) {
      // Launch the contacts app using an intent
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: 'content://contacts/people/',
      );
      await intent.launch();
    } else {
      // Open contacts URL if available

      const url = 'content://contacts/people/';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  width: isPressing ? 220 : 200, // Adjusted size for the clock
                  height: isPressing ? 220 : 200, // Adjusted size for the clock
                  child: CustomPaint(
                    size: Size(200, 200), // Adjusted size for the clock
                    painter: ClockBorderPainter(_controller, isPressing),
                    child: Center(
                      child: Text(
                        _getCurrentTime(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isPressing ? 40 : 36, // Adjusted font size
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Contact Icon Widget
          Positioned(
            bottom: 80, // Adjusted position of the phone icon
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _openContactsApp,
              child: Icon(
                Icons.phone,
                color: Colors.white,
                size: 50, // Adjusted size of the phone icon
              ),
            ),
          ),
        ],
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
