import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_app/utils/string_const.dart';


void handleErrors(BuildContext context, String message) {

  printError(message);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Alert"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ],
    ),
  );
}
