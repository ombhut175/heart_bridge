import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<XFile?> pickImageFromCamera() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    print('Picked from camera: ${image.path}');
  }
  return image;
}

Future<XFile?> pickImageFromGallery() async {
  print("::: pick image from gallery :::");

  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  return image;
}
