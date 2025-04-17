import 'package:matrimony_app/utils/string_const.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static const String TBL_USER = 'Tbl_User';
  // static const String USER_ID = 'UserID';
  // static const String NAME = 'Name';
  // static const String EMAIL = "Email";
  // static const String MOBILE_NUMBER = "Mobile_Number";
  // static const String DOB = 'Dob';
  // static const String GENDER = "Gender";
  // static const String CITY = "City";
  // static const String IS_FAVOURITE = 'IsFavourite';

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

  //for hobbies table
  static const String TBL_HOBBIES = "Tbl_Hobbies";
  static const String HOBBY_ID = "HobbyId";
  static const String HOBBY_NAME = "HobbyName";

  //table for hobbies and userId relation

  static const String TBL_USER_HOBBIES = "Tbl_User_Hobbies";

  //table for favourite users

  static const String TBL_FAVOURITE_USERS = "Tbl_Favourite_Users";

  int DB_VERSION = 1;

  Future<Database> initDatabase() async {
    Database db = await openDatabase(
      '${await getDatabasesPath()}/Matrimony.db',
      version: DB_VERSION,
      onCreate: (db, version) async {
        print("Creating table $TBL_USER");

        await db.execute('CREATE TABLE $TBL_USER ( '
            '$USER_ID INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$NAME TEXT NOT NULL, '
            '$IS_FAVOURITE INTEGER NOT NULL DEFAULT (0), '
            '$DOB TEXT,'
            '$EMAIL TEXT UNIQUE NOT NULL, '
            '$MOBILE_NUMBER INTEGER UNIQUE NOT NULL, '
            '$GENDER TEXT NOT NULL, '
            '$CITY TEXT);'
            );

        await db.execute(
            'CREATE TABLE $TBL_HOBBIES ( $HOBBY_ID INTEGER PRIMARY KEY, $HOBBY_NAME TEXT );');

        await db.execute('CREATE TABLE $TBL_USER_HOBBIES ( '
            '$USER_ID INTEGER NOT NULL, '
            '$HOBBY_ID INTEGER NOT NULL, '
            'FOREIGN KEY ($USER_ID) REFERENCES $TBL_USER($USER_ID) ON DELETE  CASCADE ON UPDATE CASCADE, '
            'FOREIGN KEY ($HOBBY_ID) REFERENCES $TBL_HOBBIES($HOBBY_ID) ON DELETE CASCADE ON UPDATE CASCADE);');

        await db.execute("INSERT INTO $TBL_HOBBIES (HobbyId, HobbyName) VALUES "
            "(1, 'Sports'), (2, 'Video gaming'), (3, 'Book Reading'), (4, 'Music'), (5, 'DHH');");

        await db.execute(
            "CREATE TABLE $TBL_FAVOURITE_USERS ( $USER_ID INTEGER REFERENCES $TBL_USER ($USER_ID) ON DELETE CASCADE ON UPDATE CASCADE MATCH SIMPLE NOT NULL );");
      },
      onOpen: (db) async {
        // Enable foreign keys when opening the database
        await db.execute("PRAGMA foreign_keys = ON;");
      },
    );

    return db;
  }
}
