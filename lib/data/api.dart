import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class userData {
  static final String baseUrl = 'http://10.61.36.108:3000';
  final _myBox = Hive.box('myBox');

  Future<http.Response> getApi({
    required String endurl,
  }) async {
    final url = Uri.parse('$baseUrl/$endurl');

    try {
      print('ayush Bearer ${_myBox.get('token')}');
      final response = await http.get(url, headers: {
        'Authorization': '${_myBox.get('token')}',
        'Content-Type': 'application/json',
      });
      final responseBody = jsonDecode(response.body);
      print(responseBody.toString() + "subhi");
      return response;
    } catch (e) {
      if (e is SocketException) {
        throw Exception('please check your network connection');
      }
      throw Exception('problem while sending request to server');
    }
  }

  Future<http.Response> postApi({
    required String endurl,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$baseUrl/$endurl');

    try {
      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer ${_myBox.get('token')}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      return response;
    } catch (e) {
      if (e is SocketException) {
        throw Exception('please check your network connection');
      }
      throw Exception('problem while sending request to server');
    }
  }
}
