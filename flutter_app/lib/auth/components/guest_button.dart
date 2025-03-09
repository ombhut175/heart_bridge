import 'package:flutter/material.dart';
import 'package:matrimony_app/dashboard/dashboard_screen_bottom_navigation_bar.dart';
import 'package:matrimony_app/utils/string_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final EdgeInsetsGeometry margin;

  const GuestButton({
    Key? key,
    this.text = 'Continue as Guest',
    this.onPressed,
    this.height = 48,
    this.width = double.infinity,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);


  static void continueAsGuest(BuildContext context) {

    // Navigate to the dashboard as a guest user
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreenBottomNavigationBar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed ?? () => continueAsGuest(context),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}