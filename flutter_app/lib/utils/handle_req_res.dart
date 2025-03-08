import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony_app/utils/services.dart';
import 'package:matrimony_app/utils/string_const.dart';

dynamic handleApiResponse(http.Response response) {
  try {
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody; // Return decoded JSON data
    } else {
      String errorMessage =
          responseBody["message"] ?? "Unexpected error occurred";
      throw Exception("Error ${response.statusCode}: $errorMessage");
    }
  } catch (e) {
    rethrow;
  }
}

Future<dynamic> postRequest({
  required String url,
  required body,
}) async {
  try {
    Services.showProgressDialogEasyLoading();

    http.Response response = await http.post(
      Uri.parse(dotenv.env[BACKEND_URL]! + url),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  }finally{
    Services.dismissProgressEasyLoading();
  }
}


Future<dynamic> patchRequest({
  required String url,
  required body,
}) async {
  try {
    Services.showProgressDialogEasyLoading();

    http.Response response = await http.patch(
      Uri.parse(dotenv.env[BACKEND_URL]! + url),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  }finally{
    Services.dismissProgressEasyLoading();
  }
}