import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:minimalist/blocs/error/error_bloc.dart';
import 'package:minimalist/data/api.dart';
import 'package:minimalist/veiw/homeScreen.dart';
import 'package:minimalist/veiw/subscriptionScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

Future<void> loginRepository(
    {required BuildContext context,
    required String otp,
    required String phone}) async {
  try {
    final userRepository = Provider.of<userData>(context, listen: false);
    final response = await userRepository
        .postApi(endurl: 'login', body: {'phone': phone, 'otp': otp});
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final token = responseBody['token'];
      final _myBox = Hive.box('myBox');
      _myBox.put('token', token);
      print(_myBox.get('token'));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubscriptionScreen(),
        ),
      );
    } else {
      context.read<ErrorBloc>().add(SetError(responseBody['error']));
    }
  } catch (e) {
    context.read<ErrorBloc>().add(SetError(e.toString()));
  }
}
