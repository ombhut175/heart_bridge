import 'package:matrimony_app/utils/exports/main.dart';

class SharedPreferenceServices {
  static SharedPreferences? _preferences;

  static Future<void> _create() async {
    if(_preferences!=null) return;

    _preferences = await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> getPreferences() async {
    await _create();

    return _preferences!;
  }

  static void setUserDetails(){

  }

  static Future<void> removeAllPreferences() async {
    await _create();

    await _preferences!.clear();
  }

  static Future<bool> isCloudUser() async {
    await _create();

    return  _preferences!.getBool(IS_USER_LOGIN) ?? false;
  }

}