import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:matrimony_app/about_page/about_page.dart';
import 'package:matrimony_app/add_edit_user/add_edit_user_screen.dart';
import 'package:matrimony_app/list_view/list_view.dart';

class DashboardScreenBottomNavigationBar extends StatefulWidget {
  const DashboardScreenBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<DashboardScreenBottomNavigationBar> createState() =>
      _DashboardScreenBottomNavigationBarState();
}

class _DashboardScreenBottomNavigationBarState
    extends State<DashboardScreenBottomNavigationBar> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  final GlobalKey<UserListPageState> _userListKey = GlobalKey<UserListPageState>();

  // Only three pages now.
  List<Widget> _pages = [
    UserListPage(key: UniqueKey()),
    UserListPage(isFavourite: true, key: UniqueKey()),
    AboutPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Reassign with our desired keys.
    _pages = [
      UserListPage(key: _userListKey),
      UserListPage(isFavourite: true, key: UniqueKey()),
      AboutPage(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    const iconColors = Colors.white;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        items: <Widget>[
          // First item: Users
          Column(
            mainAxisSize: MainAxisSize.min, // Use minimal vertical space
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, color: _selectedIndex == 0 ? iconColors : Colors.grey),
              Text(
                "Users",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 0 ? iconColors : Colors.grey,
                ),
              ),
            ],
          ),
          // Second item: Favorites
          Column(
            mainAxisSize: MainAxisSize.min, // Use minimal vertical space
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, color: _selectedIndex == 1 ? iconColors : Colors.grey),
              Text(
                "Favorites",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 1 ? iconColors : Colors.grey,
                ),
              ),
            ],
          ),
          // Third item: About
          Column(
            mainAxisSize: MainAxisSize.min, // Use minimal vertical space
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: _selectedIndex == 2 ? iconColors : Colors.grey),
              Text(
                "About",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: _selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 2 ? iconColors : Colors.grey,
                ),
              ),
            ],
          ),
        ],
        color: theme.cardColor,
        buttonBackgroundColor: primaryColor,
        backgroundColor: theme.scaffoldBackgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: _onItemTapped,
      ),
    );
  }
}
