import 'package:flutter/material.dart';
import 'package:matrimony_app/about_page/about_page.dart';
import 'package:matrimony_app/add_edit_user/add_edit_user_screen.dart';
import 'package:matrimony_app/list_view/list_view.dart';
import 'package:matrimony_app/user_management/user.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      "icon": Icons.person_add,
      "name": "Add User",
      "color": Color(0xFFE91E63),
      "onTap": (context) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserEntryPage()),
        );
        if (result != null) {
          User user = await User.create();
          await user.addUser(result);
        }
      },
    },
    {
      "icon": Icons.people,
      "name": "User List",
      "color": Color(0xFF9C27B0),
      "onTap": (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserListPage()),
        );
      },
    },
    {
      "icon": Icons.favorite,
      "name": "Favourite Users",
      "color": Color(0xFFF44336),
      "onTap": (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserListPage(isFavourite: true)),
        );
      },
    },
    {
      "icon": Icons.info,
      "name": "About Us",
      "color": Color(0xFF2196F3),
      "onTap": (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutPage()),
        );
      },
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
            colors: [Color(0xFFE91E63), Color(0xFFFFC107)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "Matrimonial App",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
                    padding: const EdgeInsets.all(24),
                    children: List.generate(
                      menuItems.length,
                          (index) => AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: _buildMenuItem(context, menuItems[index]),
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

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => item['onTap'](context),
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: item['color'],
                shape: BoxShape.circle,
              ),
              child: Icon(
                item['icon'],
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              item['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: item['color'],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

