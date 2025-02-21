import 'package:flutter/material.dart';
import 'package:matrimony_app/auth/login_page.dart';
import 'package:matrimony_app/dashboard/dashboard_screen.dart';
import 'package:matrimony_app/database/my_database.dart';
import 'package:matrimony_app/design/welcome_screen.dart';
import 'package:matrimony_app/utils/string_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard/dashboard_screen_bottom_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrimony App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFE91E63),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFE91E63),
          secondary: Color(0xFFF8BBD0), // Light pink
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFFE91E63),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if(snapshot.data!.getBool(IS_USER_LOGIN) != null && snapshot.data!.getBool(IS_USER_LOGIN)!){
              return DashboardScreenBottomNavigationBar();
            }else{
              return LoginPage();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
