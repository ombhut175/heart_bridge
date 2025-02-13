import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_app/about_page/about_page.dart';
import 'package:matrimony_app/add_edit_user/add_edit_user_screen.dart';
import 'package:matrimony_app/list_view/list_view.dart';

class DashboardScreenBottomNavigationBar extends StatefulWidget {
  const DashboardScreenBottomNavigationBar({super.key});

  @override
  State<DashboardScreenBottomNavigationBar> createState() =>
      _DashboardScreenBottomNavigationBarState();
}

class _DashboardScreenBottomNavigationBarState
    extends State<DashboardScreenBottomNavigationBar> {
  static const String ICON = "Icon";
  static const String LABEL = "Label";

  final List<Map<String, dynamic>> menuItems = [
    { ICON: Icons.people, LABEL: "User List", },
    { ICON: Icons.favorite, LABEL: "Favourite Users", },
    { ICON: Icons.info, LABEL: "About Us", },
  ];

  /// Use UniqueKey to force a new instance so that Flutter does not re-use the old state.
  final List<Widget Function()> pageBuilders = [
        () => UserListPage(key: UniqueKey()),
        () => UserListPage(isFavourite: true, key: UniqueKey()),
        () => AboutPage(),
  ];

  int selectedBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageBuilders[selectedBottomIndex](), // Always creates a new instance
      backgroundColor: const Color(0xFFE91E63),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            selectedBottomIndex = index;
          });
        },
        currentIndex: selectedBottomIndex,
        items: menuItems.map(
              (e) {
            return BottomNavigationBarItem(
              icon: Icon(e[ICON]),
              label: e[LABEL],
            );
          },
        ).toList(),
      ),
    );
  }
}
