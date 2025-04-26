import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:matrimony_app/utils/exports/auth.dart';

class DioFunctions {
  static Dio? _dio;

  static void resetDio() {
    _dio = null;
  }

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
    await _checkInternet();
    await _create();
    dynamic responseBody = await _dio!.post(url, data: data);

    return responseBody;
  }

  static Future<Response> patchRequest({
    required String url,
    required dynamic data,
  }) async {
    await _checkInternet();
    await _create();
    dynamic responseBody = await _dio!.patch(url, data: data);

    return responseBody;
  }

  static Future<Response> putRequest({
    required String url,
    required dynamic data,
  }) async {
    await _checkInternet();
    await _create();
    dynamic responseBody = await _dio!.put(url, data: data);

    return responseBody;
  }

  static Future<Response> deleteRequest({
    required String url,
    required dynamic data,
  }) async {
    await _checkInternet();
    await _create();
    dynamic responseBody = await _dio!.delete(url, data: data);

    return responseBody;
  }

  static Future<Response> getRequest({
    required String url,
  }) async {
    await _checkInternet();
    await _create();
    dynamic responseBody = await _dio!.get(url);

    return responseBody;
  }

  static Future<Map<String, String>> _getHeaders() async {
    String? token = await Services.getToken();

    return {
      "Content-Type": "application/json",
      if (token != null) AUTHORIZATION: "$BEARER $token",
      'origin': Services.giveBackendSecretHeader() ?? "",
    };
  }

  static Future<void> _checkInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    bool isInternetAvailable = await
    InternetConnectionChecker.instance.hasConnection;


    if (connectivityResult == ConnectivityResult.none || !isInternetAvailable) {

      throw new Exception("No Internet Connection found");

    }
  }
}
