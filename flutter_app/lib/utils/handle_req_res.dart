import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:matrimony_app/services/functions/dio_functions.dart';
import 'package:matrimony_app/utils/secure_storage_services.dart';
import 'package:matrimony_app/utils/services.dart';
import 'package:matrimony_app/utils/string_const.dart';


dynamic handleApiResponse(Response response) {
  print("::: from handle api response :::");
  try {

    Map<String, dynamic> responseBody = response.data;

    if (!responseBody[SUCCESS]) {
      String errorMessage =
          responseBody[MESSAGE] ?? "Unexpected error occurred";
      throw Exception("Error ${response.statusCode}: $errorMessage");
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return responseBody;
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

    Response response = await DioFunctions.postRequest(url: url, data: body);

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
  try {
    Services.showProgressDialogEasyLoading();

    Response response = await DioFunctions.patchRequest(url: url, data: body);

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

    Response response = await DioFunctions.putRequest(url: url, data: body);

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
    print("::: get request :::");

    Response response = await DioFunctions.getRequest(url: url);
    
    print(response);
    
    return handleApiResponse(response);
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<dynamic> deleteRequest({
  required String url,
  required body,
}) async {
  try {
    Services.showProgressDialogEasyLoading();

    Response response = await DioFunctions.deleteRequest(
      url: url,
      data: body,
    );

    return handleApiResponse(response);
  } catch (error) {
    rethrow;
  } finally {
    Services.dismissProgressEasyLoading();
  }
}

Future<dynamic> postRequestForLogOut() async {
  try {
    Services.showProgressDialogEasyLoading();

    Response response = await DioFunctions.postRequest(
      url: "${Services.giveBackendHostUrl()}/api/user/log-out",
      data: null,
    );


    await SecureStorageServices.removeToken();

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
