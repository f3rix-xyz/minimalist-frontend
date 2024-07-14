import 'package:flutter/material.dart';
import 'package:minimalist/repository/user_repository.dart';
import 'package:minimalist/veiw/homeScreen.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String? name;
  final String phone;
  final String process;

  OtpScreen({this.name, required this.phone, required this.process});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  String? _errorMessage;

  void _submit() async {
    final otp = _otpController.text;

    try {
      final userRepository =
          Provider.of<UserRepository>(context, listen: false);

      if (widget.process == 'signup') {
        await userRepository.createUser(
          phone: widget.phone,
          otp: otp,
          name: widget.name!,
        );
      } else if (widget.process == 'login') {
        await userRepository.loginUser(
          phone: widget.phone,
          otp: otp,
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // Replace HomeScreen() with your home screen widget
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
              maxLength: 6,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
            if (_errorMessage != null) ...[
              SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
