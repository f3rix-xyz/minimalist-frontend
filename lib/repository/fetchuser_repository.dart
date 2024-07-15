import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:minimalist/blocs/error/error_bloc.dart';
import 'package:minimalist/data/api.dart';
import 'package:minimalist/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

Future<User?> fetchuserRepository({required BuildContext context}) async {
  try {
    final userRepository = Provider.of<userData>(context, listen: false);
    final response = await userRepository.getApi(endurl: 'getUser');
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final _myBox = Hive.box('myBox');
      _myBox.put('user', responseBody['user']);
      return responseBody['user'] != null
          ? User.fromJson(responseBody['user'])
          : null;
    } else {
      context.read<ErrorBloc>().add(SetError(responseBody['error']));
    }
  } catch (e) {
    context.read<ErrorBloc>().add(SetError(e.toString()));
  }
}
