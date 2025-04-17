import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:matrimony_app/services/models/database/my_database.dart';
import 'package:matrimony_app/utils/secure_storage_services.dart';
import 'package:matrimony_app/utils/string_const.dart';
import 'package:matrimony_app/utils/ui_helpers.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Services {
  static ProgressDialog? pd;
  static SharedPreferences? preferences;

  static const Map<int, String> categoryHobbyMap = {
    1: 'Sports',
    2: 'Video gaming',
    3: 'Book Reading',
    4: 'Music',
    5: 'DHH',
  };

  static const Map<String, int> hobbyCategoryMap = {
    'Sports': 1,
    'Video gaming': 2,
    'Book Reading': 3,
    'Music': 4,
    'DHH': 5,
  };

  static const Map<String, int> hobbies = {
    "Reading":0,
    "Writing":0,
    "Singing":0,
    "Gaming" :0,
    "Sports" :0
  };

  static Future<Map<String, int>> getHobbies() async {
    Database db = await MyDatabase().initDatabase();
    List<Map<String, dynamic>> hobbyNames =
        await db.query(MyDatabase.TBL_HOBBIES);

    Map<String, int> hobbies = {};
    for (var hobby in hobbyNames) {
      hobbies[hobby[MyDatabase.HOBBY_NAME]] = 0;
    }
    return hobbies;
  }

  static void showProgressDialog(context) {
    if (pd == null) {
      pd = ProgressDialog(context);
      pd!.style(
        message: 'Please Wait',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: SpinKitFadingCircle(
          itemBuilder: (context, index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
          size: 60,
        ),
        elevation: 10.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
      );
    }
    pd!.show();
  }

  static void dismissProgress() {
    if (pd != null && pd!.isShowing()) {
      pd!.hide(); // Use `hide()` instead of `dismiss()`
    }
  }

  static void showProgressDialogEasyLoading() {
    EasyLoading.show(
      status: 'Please Wait...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  static void dismissProgressEasyLoading() {
    EasyLoading.dismiss();
  }

  static String giveBackendHostUrl() {
    return dotenv.env[EnvConst.BACKEND_URL]!;
  }

  static Future<void> setSharedPreferences({
    required String email,
    required String userName,
    // required String token
  }) async {
    preferences ??= await SharedPreferences.getInstance();

    preferences!.setString(EMAIL, email);
    preferences!.setString(USER_NAME, userName);
    preferences!.setBool(IS_USER_LOGIN, true);

    // preferences!.setString(USER_TOKEN, token);
  }

  static Future<String> getUserEmailFromSharedPreferences() async {
    preferences ??= await SharedPreferences.getInstance();

    return preferences!.getString(EMAIL)!;
  }

  static Future<String?> getToken() async {
    String? token = await SecureStorageServices.getToken();

    return token;
  }

  static Future<bool> isCloudUser() async {

    String? token = await SecureStorageServices.getToken();

    return token != null;
  }

  static Future<bool> isInternetAvailable(context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult[0] == ConnectivityResult.wifi) {
      return true;
    } else {

      handleErrors(context, "Please Check your internet connection");

      return false;
    }
  }

}
