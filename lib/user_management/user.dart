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
}

