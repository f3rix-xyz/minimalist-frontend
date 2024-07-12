import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPressing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Clock Widget
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPressing = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isPressing = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  isPressing = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                width: isPressing ? 180 : 150,
                height: isPressing ? 180 : 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 6),
                ),
                child: Text(
                  _getCurrentTime(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isPressing ? 36 : 32,
                  ),
                ),
              ),
            ),
          ),

          // Contact Icon Widget
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Icon(
              Icons.phone,
              color: Colors.white,
              size: 60,
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
