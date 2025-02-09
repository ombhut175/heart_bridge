import 'package:matrimony_app/database/my_database.dart';
import 'package:sqflite/sqflite.dart';

class User {
  late Database _db;

  Map<String, int> hobbyCategoryMap = {
    'Sports': 1,
    'Video gaming': 2,
    'Book Reading': 3,
    'Music': 4,
    'DHH': 5,
  };

  User._(this._db); // Private named constructor

  static Future<User> create() async {
    Database db = await MyDatabase().initDatabase();
    return User._(db);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    return await _db.query(MyDatabase.TBL_USER);
  }

  Future<int> addUser(Map<String, dynamic> user) async {
    print("from addUser");
    print(user);
    int userId =
        await _db.insert(MyDatabase.TBL_USER, user[MyDatabase.TBL_USER]);
    print(userId);
    for (var hobby in user[MyDatabase.TBL_USER_HOBBIES].entries) {
      print(hobby);
      if (hobby.value == 1) {
        await _db.insert(MyDatabase.TBL_USER_HOBBIES, {
          MyDatabase.USER_ID: userId,
          MyDatabase.HOBBY_ID: hobbyCategoryMap[hobby.key]
        });
      }
    }
    return userId;
  }

  Future<void> deleteUser({required int userId}) async {
    print("from deleteUser");
    print(userId);
    await _db.delete(MyDatabase.TBL_USER,
        where: '${MyDatabase.USER_ID} = ?', whereArgs: [userId]);
  }

  Future<void> toggleFavourite({required int userId}) async {
    List<Map<String, dynamic>> user = await _db.query(MyDatabase.TBL_USER,
        columns: [MyDatabase.IS_FAVOURITE],
        where: "${MyDatabase.USER_ID} = ?",
        whereArgs: [userId]);

    if (user.isNotEmpty) {
      int currentStatus = user.first[MyDatabase.IS_FAVOURITE];
      int newStatus = currentStatus == 1 ? 0 : 1;

      await _db.update(
          MyDatabase.TBL_USER, {MyDatabase.IS_FAVOURITE: newStatus},
          where: "${MyDatabase.USER_ID} = ?", whereArgs: [userId]);

      print("User $userId favorite status toggled to $newStatus");
    }else{
      print("User with ID $userId not found.");
    }

  }
}
