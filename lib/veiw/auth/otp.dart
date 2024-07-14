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
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                maxLength: 6,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'OTP is required';
                  } else if (value.length != 6) {
                    return 'Enter a valid 6-digit OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40), // Increased space between elements
              OutlinedButton(
                onPressed: _submit,
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
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
      ),
    );
  }
}
