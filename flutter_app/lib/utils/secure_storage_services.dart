import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrimony_app/utils/string_const.dart';

class SecureStorageServices {
  static FlutterSecureStorage? _storage;

  dynamic get storage => _storage;

  static void create() {
    _storage ??= const FlutterSecureStorage();
  }

  static Future<void> saveToken(String token) async {
    create();

    await _storage!.write(key: USER_TOKEN, value: token);
  }

  static Future<String?> getToken() async {
    create();

    String? token = await _storage!.read(key: USER_TOKEN);

    return token;
  }

  static Future<void> removeToken() async {
    create();

    await _storage!.delete(key: USER_TOKEN);
  }
}
