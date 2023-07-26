import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../const/api_config.dart';
import '../local/secure_storage.dart';
import '../model/user.dart';

class AuthService {
  AuthService._();

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.registerEndpoint}';
      final data = {
        'name': name,
        'email': email,
        'password': password,
      };
      final response = await http.post(
        Uri.parse(url),
        body: data,
      );
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final data = responseJson['data'];
          final token = data['token'];
          final user = User.fromJson(data['user']);
          await SecureStorage.cacheToken(token: token);
          await SecureStorage.cacheUser(user: user);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      log('register $e');
      return false;
    }
  }

  static Future<bool> login({
    required String name,
    required String password,
  }) async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.loginEndpoint}';
      final data = {'name': name, 'password': password};
      final response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final data = responseJson['data'];
          final token = data['token'];
          final user = User.fromJson(data['user']);
          await SecureStorage.cacheToken(token: token);
          await SecureStorage.cacheUser(user: user);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      log('$e');
      return false;
    }
  }

  static Future<bool?> logout() async {
    try {
      const url = "${ApiConfig.baseUrl}/${ApiConfig.logoutEndpoint}";
      final token = await SecureStorage.getToken();
      final header = {'authorization': 'Bearer $token'};
      final response = await http.post(Uri.parse(url), headers: header);
      if (response.statusCode == 200) {
        log(response.body);
        return true;
      }
    } catch (e) {
      log("logout $e");
      return false;
    }
    return null;
  }
}
