import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matrimony_app/auth/login_page.dart';
import 'package:matrimony_app/pages/home.dart';
import 'package:matrimony_app/utils/string_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              if(snapshot.data!.getBool(IS_USER_LOGIN) != null && snapshot.data!.getBool(IS_USER_LOGIN)!){
                return Home();
              }else{
                return LoginPage();
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink, // Change as per your theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child:  CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.favorite, size: 50, color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Matrimony App',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black26,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
