import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:matrimony_app/utils/exports/auth.dart';

class DioFunctions {
  static Dio? _dio;

  static Future<void> _create() async {
    print("::: create dio :::");
    print("::: base url = ${Services.giveBackendHostUrl()}:::");

    if (_dio != null) return;

    _dio = Dio();

    _dio!.options.baseUrl = Services.giveBackendHostUrl();

    _dio!.options.headers = await _getHeaders();

  }


  static Future<Response> postRequest({
    required String url,
    required dynamic data,
  }) async {
    await _create();
    dynamic responseBody = await _dio!.post(url,data: data);

    return responseBody;
  }

  static Future<Response> patchRequest({
    required String url,
    required dynamic data,
  }) async {
    await _create();
    dynamic responseBody = await _dio!.patch(url,data: data);

    return responseBody;
  }

  static Future<Response> putRequest({
    required String url,
    required dynamic data,
  }) async {
    await _create();
    dynamic responseBody = await _dio!.put(url,data: data);

    return responseBody;
  }

  static Future<Response> deleteRequest({
    required String url,
    required dynamic data,
  }) async {
    await _create();
    dynamic responseBody = await _dio!.delete(url,data: data);

    return responseBody;
  }

  static Future<Response> getRequest({
    required String url,
  }) async {

    await _create();
    dynamic responseBody = await _dio!.get(url);

    return responseBody;
  }

  static Future<Map<String, String>> _getHeaders() async {
    print("::: get Headers :::");

    String? token = await Services.getToken();

    print("::: token = :::");
    print(token);

    return {
      "Content-Type": "application/json",
      if (token != null) AUTHORIZATION: "$BEARER $token",
      'origin': dotenv.env[EnvConst.BACKEND_SECRET_HEADER] ?? "",
    };
  }


}
