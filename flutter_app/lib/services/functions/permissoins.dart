

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissions() async {
  // if()


  var cameraStatus = await Permission.camera.request();
  var photosStatus = await Permission.photos.request();

  return cameraStatus.isGranted && photosStatus.isGranted;
}
