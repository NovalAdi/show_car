import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../const/api_config.dart';
import '../local/secure_storage.dart';
import '../model/car.dart';

class CarService {
  CarService._();

  static Future<Car?> getMainCar() async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.carEndpoint}/main';
      final token = await SecureStorage.getToken();
      final header = {'authorization': 'Bearer $token'};
      final response = await http.get(Uri.parse(url), headers: header);
      log(response.body);
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          final car = Car.fromJson(responseJson['data']);
          return car;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<List<Car>?> getListCar() async {
    try {
      const url = '${ApiConfig.baseUrl}/${ApiConfig.carEndpoint}';
      final token = await SecureStorage.getToken();
      final header = {'authorization': 'Bearer $token'};
      final response = await http.get(Uri.parse(url), headers: header);
      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final status = responseJson['status'];
        if (status == true) {
          List<Car> listCar = [];
          for (final json in responseJson['data']) {
            listCar.add(Car.fromJson(json));
          }
          return listCar;
        }
      }
    } catch (e) {
      log('getListCar $e');
    }
    return null;
  }

  static Future<bool?> createCar({
    required String name,
    required String brand,
    required String price,
    required image,
  }) async {
    final file = await MultipartFile.fromFile(image.path);
    try {
      final dio = Dio();
      final token = await SecureStorage.getToken();
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      final response = await dio.post(
        "${ApiConfig.baseUrl}/${ApiConfig.carEndpoint}/${ApiConfig.createEndpoint}",
        data: FormData.fromMap({
          'name': name,
          'brand': brand,
          'price': price,
          'image': file,
        }),
        options: Options(
          headers: headers,
        ),
      );
      log("${response.data}");
      return true;
    } catch (e) {
      log('createCar $e');
    }
  }

  static Future<bool?> updateCar({
    required String id,
    required String name,
    required String brand,
    required String price,
    required image,
  }) async {
    if (image != null) {
      final file = await MultipartFile.fromFile(image.path);
      try {
        final dio = Dio();
        final token = await SecureStorage.getToken();
        log("$token");
        final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
        final response = await dio.post(
          "${ApiConfig.baseUrl}/${ApiConfig.carEndpoint}/${ApiConfig.createEndpoint}/$id",
          data: FormData.fromMap({
            'name': name,
            'brand': brand,
            'price': price,
            'image': file,
          }),
          options: Options(
            headers: headers,
          ),
        );
        log("${response.data} response update car");
        return true;
      } catch (e) {
        log('createCar $e');
        return false;
      }
    }
    final url =
        '${ApiConfig.baseUrl}/${ApiConfig.carEndpoint}/${ApiConfig.updateEndpoint}/$id';
    final token = await SecureStorage.getToken();
    final header = {'authorization': 'Bearer $token'};
    final body = {
      'name': name,
      'brand': brand,
      'price': price,
    };
    final response =
        await http.post(Uri.parse(url), headers: header, body: body);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<void> deleteCar({required String id}) async {
    try {
      final url = "${ApiConfig.baseUrl}/${ApiConfig.carEndpoint}/${ApiConfig.deleteEndpoint}/$id";
      final token = await SecureStorage.getToken();
      final header = {'authorization': 'Bearer $token'};
      final response = await http.delete(Uri.parse(url),headers: header);
      log(response.body);
      if (response.statusCode == 200) {
        log("delete succeed");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
