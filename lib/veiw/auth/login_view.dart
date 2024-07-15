import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist/blocs/error/error_bloc.dart';
import 'package:minimalist/repository/otp_repository.dart';
import 'package:minimalist/repository/user_repository.dart';
import 'package:minimalist/veiw/auth/otp_view.dart';
import 'package:minimalist/veiw/auth/signup_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = _phoneController.text;

      context.read<ErrorBloc>().add(ClearError());
      try {
        await otpRepository(
            context: context, process: 'login', phone: '+91' + phone);
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
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile number is required';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(
                  height: 60), // Increased space between text field and button
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
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text('Create an account',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}