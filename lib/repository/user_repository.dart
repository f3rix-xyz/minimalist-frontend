import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:minimalist/models/user.dart';

class UserRepository {
  final _myBox = Hive.box('myBox');
  Future<User?> fetchUser() async {
    final url = Uri.parse('http://localhost:3000/getUser');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${_myBox.get('token')}',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        // If the server returns a successful response, parse the JSON
        final jsonBody = jsonDecode(response.body);
        return User.fromJson(jsonBody['user']);
      } else {
        // Handle other status codes as needed
        print('Failed to load user data, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> createUser({
    required String phone,
    required String otp,
    required String name,
  }) async {
    final url = Uri.parse('http://localhost:3000/createUser');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];
        _myBox.put('token', token);
        print('User created successfully and token saved to Hive box.');
      } else {
        print('Failed to create user, status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<void> loginUser({
    required String phone,
    required String otp,
  }) async {
    final url = Uri.parse('http://localhost:3000/login');

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

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];

        // Store the token in Hive
        _myBox.put('token', token);

        print('Login successful and token stored.');
      } else {
        print('Failed to login, status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error logging in: $e');
    }
  }
}
