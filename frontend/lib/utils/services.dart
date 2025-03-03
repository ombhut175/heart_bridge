import 'package:matrimony_app/database/my_database.dart';
import 'package:sqflite/sqflite.dart';


class Services{
    static Future<Map<String, int>> getHobbies() async {
      Database db = await MyDatabase().initDatabase();
      List<Map<String, dynamic>> hobbyNames = await db.query(MyDatabase.TBL_HOBBIES);
      Map<String, int> hobbies = {};
      for (var hobby in hobbyNames) {
        hobbies[hobby[MyDatabase.HOBBY_NAME]] = 0;
      }
      return hobbies;
    }
}
