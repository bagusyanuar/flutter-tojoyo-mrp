import 'dart:developer';

import 'package:app_tojoyo_mrp/controller/util.dart';
import 'package:dio/dio.dart';

class LoginResponse {
  bool error;
  String message;
  String accessToken;

  LoginResponse({
    required this.error,
    required this.message,
    required this.accessToken,
  });
}

Future<LoginResponse> loginHandler(Map<String, String> data) async {
  LoginResponse loginResponse = LoginResponse(
    error: true,
    message: 'internal server error',
    accessToken: '',
  );
  try {
    var formData = FormData.fromMap(data);
    final response = await Dio().post("$hostApiAddress/login",
        options: Options(headers: {"Accept": "application/json"}),
        data: formData);
    final int status = response.data["status"] as int;
    final String message = response.data["message"] as String;
    log(response.toString());
    if (status == 200) {
      final String token = response.data["data"]["access_token"] as String;
      loginResponse = LoginResponse(
        error: false,
        message: 'success',
        accessToken: token,
      );
    } else {
      log("Login Failed");
      loginResponse = LoginResponse(
        error: true,
        message: 'internal server error',
        accessToken: '',
      );
    }
  } on DioException catch (e) {
    log("Error ${e.response}");
    loginResponse = LoginResponse(
      error: true,
      message: 'internal server error',
      accessToken: '',
    );
  }
  return loginResponse;
}
