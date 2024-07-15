import 'dart:convert';

import 'package:minimalist/blocs/error/error_bloc.dart';
import 'package:minimalist/data/api.dart';
import 'package:minimalist/veiw/auth/otp_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

Future<void> otpRepository(
    {required BuildContext context,
    required String process,
    String? name,
    required String phone}) async {
  try {
    final userRepository = Provider.of<userData>(context, listen: false);
    final response = await userRepository
        .postApi(endurl: 'reqOTP', body: {'phone': phone, 'process': process});
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpScreen(name: name, phone: phone, process: process),
        ),
      );
    } else {
      context.read<ErrorBloc>().add(SetError(responseBody['error']));
    }
  } catch (e) {
    context.read<ErrorBloc>().add(SetError(e.toString()));
  }
}
