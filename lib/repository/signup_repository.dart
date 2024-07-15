import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:minimalist/blocs/error/error_bloc.dart';
import 'package:minimalist/data/api.dart';
import 'package:minimalist/veiw/homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

Future<void> signupRepository(
    {required BuildContext context,
    required String name,
    required String otp,
    required String phone}) async {
  try {
    final userRepository = Provider.of<userData>(context, listen: false);
    final response = await userRepository.postApi(
        endurl: 'createUser', body: {'phone': phone, 'otp': otp, 'name': name});
    print('responsebody');
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final token = responseBody['token'];
      final _myBox = Hive.box('myBox');
      _myBox.put('token', token);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      print(responseBody['error']);
      context.read<ErrorBloc>().add(SetError(responseBody['error'] + 'hi1'));
    }
  } catch (e) {
    print(e.toString());
    context.read<ErrorBloc>().add(SetError(e.toString() + 'hi2'));
  }
}
