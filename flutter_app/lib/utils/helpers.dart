import 'package:flutter/material.dart';
import 'package:matrimony_app/pages/home.dart';

Future<void> pushAndRemoveUntilForFirstPage(context) async {
  if (!context.mounted) return;

  await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(
          isCloudUser: true,
        ),
      ),
      (Route<dynamic> route) => false);
}

Future<void> pushAndRemoveUntil({
  required BuildContext context,
  required Widget route,
}) async {
  if (!context.mounted) return;

  await Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => route),
    (route) => false,
  );
}

void pop({
  required BuildContext context,
}) {
  if (!context.mounted) return;

  Navigator.pop(context);
}

Future<void> pushReplacement({
  required BuildContext context,
  required Widget route,
}) async {
  if (!context.mounted) return;

  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}

Future<void> push({
  required BuildContext context,
  required Widget route,
}) async {
  if (!context.mounted) return;

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => route,
    ),
  );
}
