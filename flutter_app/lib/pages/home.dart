import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:matrimony_app/pages/tabs/about_page.dart';
import 'package:matrimony_app/pages/tabs/users_list.dart';
import 'package:matrimony_app/pages/tabs/profile_page.dart';

class Home extends StatefulWidget {
  final bool isCloudUser;

  const Home({Key? key, this.isCloudUser = false})
      : super(key: key);

  @override
  State<Home> createState() =>
      _HomeState();
}

class _HomeState
    extends State<Home>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late List<Widget> _pages = [];



  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _pages = [
      UserListPage(key: UniqueKey(),isCloudUser: widget.isCloudUser,),
      UserListPage(isFavourite: true,isCloudUser: widget.isCloudUser ,key: UniqueKey()),
      AboutPage(),
      ProfilePage()
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people,
                  color: _selectedIndex == 0 ? iconColors : Colors.grey),
              Text(
                "Users",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                  _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 0 ? iconColors : Colors.grey,
                ),
              ),
            ],
          ),
          // Second item: Favorites
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite,
                  color: _selectedIndex == 1 ? iconColors : Colors.grey),
              Text(
                "Favorites",
                style: TextStyle(
                  fontSize: _selectedIndex == 1 ? 7 : 12,
                  fontWeight:
                  _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 1 ? iconColors : Colors.grey,
                ),
              ),
            ],
          ),
          // Third item: About
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info,
                  color: _selectedIndex == 2 ? iconColors : Colors.grey),
              Text(
                "About",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                  _selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 2 ? iconColors : Colors.grey,
                ),
              ),
            ],
          ),
          // Fourth item: Profile
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person,
                  color: _selectedIndex == 3 ? iconColors : Colors.grey),
              Text(
                "Profile",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                  _selectedIndex == 3 ? FontWeight.bold : FontWeight.normal,
                  color: _selectedIndex == 3 ? iconColors : Colors.grey,
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