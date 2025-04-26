import 'package:matrimony_app/utils/handle_req_res.dart';
import 'package:matrimony_app/utils/services.dart';
import 'package:matrimony_app/utils/string_const.dart';
import 'package:matrimony_app/utils/ui_helpers.dart';

class UserApiService {
  Future<List<Map<String, dynamic>>> getUsers(context) async {
    try {
      print("::: from UserApiService :::");

      String email = await Services.getUserEmailFromSharedPreferences();

      dynamic responseBody =
          await getRequest(url: ApiUserConstants.USER);

      List<dynamic> rawList = responseBody[BODY];

      print(rawList);

      List<Map<String, dynamic>> ans =
          rawList.map((e) => Map<String, dynamic>.from(e)).toList();

      print(ans);

      return ans;
    } catch (error) {
      handleErrors(context, error);

      rethrow;
    }
  }

  dynamic addUser(
      {required Map<String, dynamic> user, required context}) async {
    try {
      dynamic responseBody = await postRequest(url: ApiUserConstants.USER, body: user);

      print(responseBody);
      return responseBody;
    } catch (error) {
      handleErrors(context, error);
    }
  }

  dynamic updateUser(
      {required Map<String, dynamic> user, required context}) async {
    try {

      dynamic responseBody =
          await putRequest(url: "${ApiUserConstants.USER}/${user[USER_ID]}", body: user);

      print(responseBody);
      return responseBody;
    } catch (error) {
      handleErrors(context, error);
    }
  }

  dynamic deleteUser({required String userId, required context}) async {
    try {
      print("::: from deleteUser :::");

      print(userId);

      String email = await Services.getUserEmailFromSharedPreferences();

      dynamic responseBody = await deleteRequest(
          url: "${ApiUserConstants.USER}/$userId", body: {ADMIN_EMAIL: email});

      return responseBody[SUCCESS];
    } catch (error) {
      handleErrors(context, error);
    }
  }

  dynamic toggleFavourite({required String userId, required context}) async {
    try {
      String email = await Services.getUserEmailFromSharedPreferences();

      dynamic responseBody =
          await patchRequest(url: "${ApiUserConstants.TOGGLE_FAVORITE}/$userId", body: {
        ADMIN_EMAIL: email,
      });

      return responseBody[SUCCESS];
    } catch (error) {
      handleErrors(context, error);
    }
  }

  Future<List<Map<String, dynamic>>> getFavouriteUsers(context) async {
    try {

      String email = await Services.getUserEmailFromSharedPreferences();

      dynamic responseBody =
          await getRequest(url: ApiUserConstants.USER);

      List<dynamic> rawList = responseBody[BODY];

      print(rawList);

      // Filter users where isFavourite == 1
      List<Map<String, dynamic>> ans = rawList
          .where((e) =>
              e[IS_FAVOURITE] == 1) // Ensure only favourite users are included
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      print(ans);

      return ans;
    } catch (error) {
      handleErrors(context, error);
      rethrow;
    }
  }
}
