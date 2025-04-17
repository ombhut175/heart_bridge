import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony_app/utils/secure_storage_services.dart';
import 'package:matrimony_app/utils/services.dart';
import 'package:matrimony_app/utils/string_const.dart';


dynamic handleApiResponse(http.Response response) {
  print("::: from handle api response :::");
  try {
    print(response.body);

    Map<String, dynamic> responseBody = jsonDecode(response.body);

    print(responseBody);

    if (!responseBody[SUCCESS]) {
      String errorMessage =
          responseBody[MESSAGE] ?? "Unexpected error occurred";
      throw Exception("Error ${response.statusCode}: $errorMessage");
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody; // Return decoded JSON data
    } else {
      String errorMessage =
          responseBody[MESSAGE] ?? "Unexpected error occurred";
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
    print("::: post request :::");

    Services.showProgressDialogEasyLoading();

    String? token = await Services.getToken();

    print(token);

    http.Response response = await http.post(
      Uri.parse(Services.giveBackendHostUrl() + url),
      body: jsonEncode(body),
      headers: await getHeaders(),
    );

    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  } finally {
    Services.dismissProgressEasyLoading();
  }
}

Future<dynamic> patchRequest({
  required String url,
  required body,
}) async {
  print("::: from patch request");
  print(body);
  try {
    Services.showProgressDialogEasyLoading();

    http.Response response = await http.patch(
      Uri.parse(Services.giveBackendHostUrl() + url),
      body: jsonEncode(body),
      headers: await getHeaders(),
    );
    print("::: response :::");
    print(response.body);
    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  } finally {
    Services.dismissProgressEasyLoading();
  }
}

Future<dynamic> putRequest({
  required String url,
  required body,
}) async {
  try {
    Services.showProgressDialogEasyLoading();


    http.Response response = await http.put(
      Uri.parse(Services.giveBackendHostUrl() + url),
      body: jsonEncode(body),
      headers: await getHeaders(),
    );

    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  } finally {
    Services.dismissProgressEasyLoading();
  }
}

Future<dynamic> getRequest({
  required String url,
}) async {
  try {
    // Services.showProgressDialogEasyLoading();


    http.Response response =
        await http.get(Uri.parse(Services.giveBackendHostUrl() + url), headers: await getHeaders());

    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  }
  // finally{
  //   Services.dismissProgressEasyLoading();
  // }
}

Future<dynamic> deleteRequest({
  required String url,
  required body,
}) async {
  try {
    Services.showProgressDialogEasyLoading();


    http.Response response = await http.delete(
      Uri.parse(Services.giveBackendHostUrl() + url),
      body: jsonEncode(body),
      headers: await getHeaders(),
    );

    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  } finally {
    Services.dismissProgressEasyLoading();
  }
}

Future<Map<String, String>> getHeaders() async {

  print("::: get Headers :::");

  print(dotenv.env[EnvConst.BACKEND_SECRET_HEADER]);

  String? token = await Services.getToken();

  // if (token == null) {
  //   throw Exception("No Token Found");
  // }

  Map<String, String> headers = {
    "Content-Type": "application/json",
    if (token != null) AUTHORIZATION: "$BEARER $token",
    'origin': dotenv.env[EnvConst.BACKEND_SECRET_HEADER]!,
  };

  return headers;
}

Future<dynamic> postRequestForLogOut() async {
  try {

    Services.showProgressDialogEasyLoading();

    http.Response response = await http.post(
      Uri.parse("${Services.giveBackendHostUrl()}/api/user/log-out"),
      headers: await getHeaders(),
    );

    await SecureStorageServices.removeToken();

    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  } finally {
    Services.dismissProgressEasyLoading();
  }
}