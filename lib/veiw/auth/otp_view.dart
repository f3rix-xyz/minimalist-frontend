import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist/blocs/error/error_bloc.dart';

import 'package:minimalist/repository/login_respository.dart';
import 'package:minimalist/repository/signup_repository.dart';
import 'package:minimalist/repository/user_repository.dart';
import 'package:minimalist/veiw/homeScreen.dart';

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

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final otp = _otpController.text;

      context.read<ErrorBloc>().add(ClearError());
      try {
        if (widget.process == 'signup') {
          await signupRepository(
            context: context,
            name: widget.name!,
            otp: otp,
            phone: widget.phone,
          );
        } else {
          await loginRepository(
            context: context,
            otp: otp,
            phone: widget.phone,
          );
        }
        // Handle success scenario
      } catch (e) {
        // Set error on failure
        context.read<ErrorBloc>().add(SetError(e.toString()));
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
              BlocBuilder<ErrorBloc, ErrorState>(
                builder: (context, state) {
                  if (state is ErrorMessage) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
