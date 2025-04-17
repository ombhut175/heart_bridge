import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:matrimony_app/auth/login_page.dart';
import 'package:matrimony_app/services/providers/user_provider.dart';
import 'package:matrimony_app/utils/services.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor =
        Colors.black.withOpacity(0.6) // Transparent Dark Background
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = [
      BoxShadow(
        color: Colors.blueAccent.withOpacity(0.5),
        blurRadius: 20.0,
        spreadRadius: 5.0,
      ),
    ]
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..indicatorSize = 70.0 // Bigger Indicator
    ..radius = 15.0 // Rounded Corners
    ..textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: 'Arial',
      letterSpacing: 1.2,
      color: Colors.white,
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Matrimony App',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
          primaryColor: Color(0xFFE91E63),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFE91E63),
            secondary: Color(0xFFF8BBD0), // Light pink
          ),
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
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
          future: Services.isCloudUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              print(snapshot.data);

              return snapshot.data == true
                  ? Home(
                      isCloudUser: snapshot.data!,
                    )
                  : LoginPage();
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        // home: EditProfilePage(),
      ),
    );
  }
}
