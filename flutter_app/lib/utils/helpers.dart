import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_app/dashboard/dashboard_screen_bottom_navigation_bar.dart';

void pushAndRemoveUntilForFirstPage(context){
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreenBottomNavigationBar(isCloudUser: true,),
      ),
          (Route<dynamic> route) => false);
}