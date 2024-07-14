import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:minimalist/models/user.dart';

class UserRepository {
  final _myBox = Hive.box('myBox');
  static const String baseUrl = 'http://10.61.36.108:3000';

  Future<User?> fetchUser() async {
    final url = Uri.parse('$baseUrl/getUser');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${_myBox.get('token')}',
        'Content-Type': 'application/json',
      });
      final responseBody = jsonDecode(response.body);
      return responseBody['user'] != null
          ? User.fromJson(responseBody['user'])
          : null;
    } catch (e) {
      throw Exception('problem while sending request to server');
    }
  }

  Future<dynamic> createUser({
    required String phone,
    required String otp,
    required String name,
  }) async {
    final url = Uri.parse('$baseUrl/createUser');

    final body = jsonEncode({
      'phone': phone,
      'otp': otp,
      'name': name,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseBody['token'];

        // Store the token in Hive
        _myBox.put('token', token);
        return responseBody;
      } else {
        throw Exception(responseBody['error']);
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception('problem while sending request to server');
      }
    }
  }

  Future<dynamic> reqOTP({
    required String phone,
    required String process,
  }) async {
    final url = Uri.parse('$baseUrl/reqOTP');

    final body = jsonEncode({
      'phone': phone,
      'process': process,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        throw Exception(responseBody['error']);
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception('please check your network connection');
      }
      throw Exception('problem while sending request to server');
    }
  }

  Future<dynamic> loginUser({
    required String phone,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final body = jsonEncode({
      'phone': phone,
      'otp': otp,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseBody['token'];

        // Store the token in Hive
        _myBox.put('token', token);
        return responseBody;
      } else {
        throw Exception(responseBody['error']);
      }
    } catch (e) {
      throw Exception('problem while sending request to server: $e');
    }
  }
}
