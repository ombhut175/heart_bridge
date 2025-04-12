import 'package:matrimony_app/services/models/database/my_database.dart';
import 'package:matrimony_app/utils/string_const.dart';
import 'package:sqflite/sqflite.dart';

class User {
  late Database _db;

  static Map<String, int> hobbyCategoryMap = MyDatabase.hobbyCategoryMap;

  User._(this._db); // Private named constructor

  static Future<User> create() async {
    Database db = await MyDatabase().initDatabase();
    return User._(db);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    return await _db.query(MyDatabase.TBL_USER);
  }

  Future<List<Map<String, dynamic>>> getFavouriteUsers() async {
    return await _db.query(MyDatabase.TBL_USER,
        where: "${IS_FAVOURITE} = 1");
  }

  Future<void> editUser(Map<String, dynamic> user) async {
    int userId = user[MyDatabase.TBL_USER][USER_ID];

    await _db.update(MyDatabase.TBL_USER, user[MyDatabase.TBL_USER],
        where: "${USER_ID} = ? ", whereArgs: [userId]);
    await _db.delete(MyDatabase.TBL_USER_HOBBIES,
        where: "${USER_ID} = ?", whereArgs: [userId]);

    await addHobbies(
        userId: userId, hobbies: user[MyDatabase.TBL_USER_HOBBIES]);

  }

  Future<int> addUser(Map<String, dynamic> user) async {
    int userId =
        await _db.insert(MyDatabase.TBL_USER, user[MyDatabase.TBL_USER]);
    await addHobbies(
        userId: userId, hobbies: user[MyDatabase.TBL_USER_HOBBIES]);
    return userId;
  }

  Future<void> addHobbies(
      {required int userId, required Map<String, int> hobbies}) async {
    for (var hobby in hobbies.entries) {
      if (hobby.value == 1) {
        await _db.insert(MyDatabase.TBL_USER_HOBBIES, {
          USER_ID: userId,
          MyDatabase.HOBBY_ID: hobbyCategoryMap[hobby.key]
        });
      }
    }
  }

  Future<void> deleteUser({required int userId}) async {
    print("from deleteUser");
    print(userId);
    await _db.delete(MyDatabase.TBL_USER,
        where: '${USER_ID} = ?', whereArgs: [userId]);
  }

  Future<void> toggleFavourite({required int userId}) async {
    List<Map<String, dynamic>> user = await _db.query(MyDatabase.TBL_USER,
        columns: [IS_FAVOURITE],
        where: "${USER_ID} = ?",
        whereArgs: [userId]);

    if (user.isNotEmpty) {
      int currentStatus = user.first[IS_FAVOURITE];
      int newStatus = currentStatus == 1 ? 0 : 1;

      await _db.update(
          MyDatabase.TBL_USER, {IS_FAVOURITE: newStatus},
          where: "${USER_ID} = ?", whereArgs: [userId]);

      print("User $userId favorite status toggled to $newStatus");
    } else {
      print("User with ID $userId not found.");
    }
  }
}
