import 'package:image_picker/image_picker.dart';
import 'package:matrimony_app/services/functions/image_picker.dart';
import 'package:matrimony_app/services/functions/permissoins.dart';
import 'package:matrimony_app/utils/exports/main.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:matrimony_app/widgets/features/profile_image.dart';

class EditProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  final String profilePictureUrl;

  const EditProfilePage({
    super.key,
    required this.userName,
    required this.email,
    required this.profilePictureUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  XFile? image;

  @override
  void initState() {
    super.initState();

    _usernameController.text = widget.userName;
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    print("::: update profile :::");

    if (_formKey.currentState!.validate()) {
      try {
        String userName = _usernameController.text.toString();

        // Create FormData object
        final formData = FormData();

        // Add username to form data
        formData.fields.add(MapEntry(USER_NAME, userName));

        // Add image to form data if it exists
        if (image != null) {
          final bytes = await image!.readAsBytes();
          final filename = image!.name;

          // Create a MultipartFile from the image bytes
          final multipartFile = MultipartFile.fromBytes(
            bytes,
            filename: filename,
            contentType:
                MediaType('image', 'jpeg'), // Adjust content type as needed
          );

          // Add the image to form data
          formData.files.add(MapEntry(PROFILE_PICTURE, multipartFile));
        }

        // Send the form data to the server
        final response = await postRequest(
          url: ApiMainUserConstants.UPDATE_PROFILE,
          body: formData,
        );

        await Services.reFetchUser();

        pop(context: context);
      } catch (error) {
        handleErrors(context, error);
      }
    }
  }

  Future<void> handleProfilePictureClicked() async {
    // Show dialog to choose between camera and gallery
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 10),
                        Text('Take a Photo'),
                      ],
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await requestPermissions();
                    XFile? selectedImage = await pickImageFromCamera();
                    if (selectedImage != null) {
                      setState(() {
                        image = selectedImage;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 10),
                        Text('Choose from Gallery'),
                      ],
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await requestPermissions();
                    XFile? selectedImage = await pickImageFromGallery();
                    if (selectedImage != null) {
                      setState(() {
                        image = selectedImage;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: handleProfilePictureClicked,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: theme.primaryColor, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: image != null
                                ? FutureBuilder<Uint8List>(
                                    future: image!.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        return Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  )
                                : getCachedImage(
                                    imageUrl: widget.profilePictureUrl,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        prefixIcon:
                            Icon(Icons.person, color: theme.primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: theme.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: theme.primaryColor, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      enabled: false, // Make it non-editable
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Your email address',
                        prefixIcon: Icon(Icons.email, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        fillColor: Colors.grey.withOpacity(0.1),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
