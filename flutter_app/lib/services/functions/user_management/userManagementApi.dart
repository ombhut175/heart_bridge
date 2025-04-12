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
          await getRequest(url: "/api/user?$ADMIN_EMAIL=${email}");

      List<dynamic> rawList = responseBody[BODY];

      print(rawList);

      List<Map<String, dynamic>> ans =
          rawList.map((e) => Map<String, dynamic>.from(e)).toList();

      print(ans);

      return ans;
    } catch (error) {
      handleErrors(context, error.toString());

      rethrow;
    }
  }

  dynamic addUser(
      {required Map<String, dynamic> user, required context}) async {
    try {
      dynamic responseBody = await postRequest(url: "/api/user", body: user);

      print(responseBody);
      return responseBody;
    } catch (error) {
      handleErrors(context, error.toString());
    }
  }

  dynamic updateUser(
      {required Map<String, dynamic> user, required context}) async {
    try {
      print("::: from update user");
      print(user);
      print(user[USER_ID]);

      dynamic responseBody =
          await putRequest(url: "/api/user/${user[USER_ID]}", body: user);

      print(responseBody);
      return responseBody;
    } catch (error) {
      handleErrors(context, error.toString());
    }
  }

  dynamic deleteUser({required String userId, required context}) async {
    try {
      print("::: from deleteUser :::");

      print(userId);

      String email = await Services.getUserEmailFromSharedPreferences();

      dynamic responseBody = await deleteRequest(
          url: "/api/user/$userId", body: {ADMIN_EMAIL: email});

      return responseBody[SUCCESS];
    } catch (error) {
      handleErrors(context, error.toString());
    }
  }

  dynamic toggleFavourite({required String userId, required context}) async {
    try {
      String email = await Services.getUserEmailFromSharedPreferences();

      print(userId);
      dynamic responseBody =
          await patchRequest(url: "/api/user/toggleFavourite/$userId", body: {
        ADMIN_EMAIL: email,
      });

      return responseBody[SUCCESS];
    } catch (error) {
      handleErrors(context, error.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getFavouriteUsers(context) async {
    try {
      print("::: from UserApiService :::");

      String email = await Services.getUserEmailFromSharedPreferences();

      dynamic responseBody =
      await getRequest(url: "/api/user?$ADMIN_EMAIL=${email}");

      List<dynamic> rawList = responseBody[BODY];

      print(rawList);

      // Filter users where isFavourite == 1
      List<Map<String, dynamic>> ans = rawList
          .where((e) => e[IS_FAVOURITE] == 1) // Ensure only favourite users are included
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      print(ans);

      return ans;
    } catch (error) {
      handleErrors(context, error.toString());
      rethrow;
    }
  }


}
