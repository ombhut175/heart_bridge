import 'package:flutter/material.dart';
import 'package:matrimony_app/about_page/about_page.dart';
import 'package:matrimony_app/add_edit_user/add_edit_user_screen.dart';
import 'package:matrimony_app/list_view/list_view.dart';
import 'package:matrimony_app/user_management/checking.dart';
import 'package:matrimony_app/user_management/user.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> attributesList = [
    {
      "Icon": Icons.person_add,
      "Name": "Add User",
      "OnClick": (context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return UserEntryPage();
          },
        )).then(
              (value) async {
            User user = await User.create();
            await user.addUser(value);
          },
        );
      }
    },
    {
      "Icon": Icons.people,
      "Name": "User List",
      "OnClick": (context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return UserListPage();
          },
        ));
      }
    },
    {
      "Icon": Icons.favorite,
      "Name": "Favourite User",
      "OnClick": (context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return UserListPage(
              isFavourite: true,
            );
          },
        ));
      }
    },
    {
      "Icon": Icons.info,
      "Name": "About Us",
      "OnClick": (context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AboutPage();
          },
        ));
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red.shade300, Colors.red.shade700],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Matrimonial App",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(16),
                    children: List.generate(
                      attributesList.length,
                          (index) => AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: getGridView(
                              iconToUse: attributesList[index]["Icon"],
                              name: attributesList[index]["Name"],
                              onClickFunction: attributesList[index]["OnClick"],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getGridView({
    required IconData iconToUse,
    required String name,
    Function? onClickFunction,
  }) {
    return GestureDetector(
      onTap: () {
        onClickFunction!(context);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconToUse,
              size: 50,
              color: Colors.red.shade700,
            ),
            SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
