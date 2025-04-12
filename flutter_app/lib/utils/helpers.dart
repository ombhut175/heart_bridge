import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_app/pages/home.dart';

void pushAndRemoveUntilForFirstPage(context){
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Home(isCloudUser: true,),
      ),
          (Route<dynamic> route) => false);
}