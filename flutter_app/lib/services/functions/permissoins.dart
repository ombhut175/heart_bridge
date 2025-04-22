

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissions() async {
  // if()
  print("::: request permission");


  var cameraStatus = await Permission.camera.request();
  var photosStatus = await Permission.photos.request();

  print(photosStatus);
  return cameraStatus.isGranted && photosStatus.isGranted;
}
