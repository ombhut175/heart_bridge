import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:matrimony_app/services/functions/dio_functions.dart';
import 'package:matrimony_app/services/models/database/my_database.dart';
import 'package:matrimony_app/utils/exports/auth.dart';
import 'package:matrimony_app/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Services {

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
    "Reading": 0,
    "Writing": 0,
    "Singing": 0,
    "Gaming": 0,
    "Sports": 0
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

  static String getTokenFromBody({required dynamic responseBody}) {
    print("::: get token from body :::");

    print("::: response body :::");

    print(responseBody[BODY][USER_TOKEN]);

    return responseBody[BODY][USER_TOKEN];
  }

  static Future<void> fetchUser({
   required String token,
  }) async {

    await SecureStorageServices.saveToken(token);

    DioFunctions.resetDio();

    SharedPreferences preferences = await SharedPreferenceServices.getPreferences();

    dynamic responseBody = await getRequest(url: RouteConstants.GET_USER_INFO);


    preferences.setString(EMAIL, responseBody[BODY][EMAIL]);
    preferences.setString(USER_NAME, responseBody[BODY][USER_NAME]);
    preferences.setString(
        PROFILE_PICTURE_URL, responseBody[BODY][PROFILE_PICTURE_URL]);

    preferences.setBool(IS_USER_LOGIN, true);
  }

  static Future<void> reFetchUser() async {


    SharedPreferences preferences = await SharedPreferenceServices.getPreferences();


    dynamic responseBody = await getRequest(url: RouteConstants.GET_USER_INFO);


    preferences.setString(USER_NAME, responseBody[BODY][USER_NAME]);
    preferences.setString(
        PROFILE_PICTURE_URL, responseBody[BODY][PROFILE_PICTURE_URL]);

  }

  static Future<String> getUserEmailFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferenceServices.getPreferences();

    return preferences.getString(EMAIL)!;
  }

  static Future<String?> getToken() async {
    String? token = await SecureStorageServices.getToken();

    return token;
  }

  static Future<bool> isCloudUser() async {

    return await SharedPreferenceServices.isCloudUser();
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
