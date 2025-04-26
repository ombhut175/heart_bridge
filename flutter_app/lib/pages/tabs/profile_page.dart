import 'package:matrimony_app/utils/exports/main.dart';
import 'package:matrimony_app/utils/shared_preference.dart';
import 'package:matrimony_app/widgets/features/profile_image.dart';

class ProfilePage extends StatefulWidget {
  final bool isCloudUser;

  const ProfilePage({super.key, this.isCloudUser = false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: handleLogOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleLogOut() async {
    try {
      if (widget.isCloudUser) {
        await postRequestForLogOut();
      }

      SharedPreferenceServices.removeAllPreferences();

      pushAndRemoveUntil(context: context, route: const LoginPage());
    } catch (error) {
      handleErrors(context, error);
    }
  }

  String? email;
  String? userName;
  String? profilePictureUrl;

  Future<void> getUserNameAndEmail() async {
    print("::: get user name and email :::");

    SharedPreferences preferences = await SharedPreferences.getInstance();

    print(preferences.getString(PROFILE_PICTURE_URL));

    // Set values independently, even if one is null
    userName = preferences.getString(USER_NAME);
    email = preferences.getString(EMAIL);
    profilePictureUrl = preferences.getString(PROFILE_PICTURE_URL);

    // If either value is missing, log it for debugging
    if (userName == null) printWarning("Warning: userName is null");
    if (email == null) printWarning("Warning: email is null");
  }

  void navigateToEditPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfilePage(
            email: email!,
            userName: userName!,
            profilePictureUrl: profilePictureUrl!,
          ),
        )).then(
      (value) {
        getUserNameAndEmail().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserNameAndEmail().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getUserNameAndEmail(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Header with Background
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Profile Picture
                              Container(
                                  width: 100,
                                  // You might want to adjust or remove fixed dimensions
                                  height: 100,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle, // Remove this line
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    // Optionally add rounded corners if you still want some rounding
                                    // borderRadius: BorderRadius.circular(15),
                                  ),
                                  // Use ClipRRect if you added borderRadius above
                                  // child: ClipRRect(
                                  //   borderRadius: BorderRadius.circular(15), // Match the radius
                                  //   child: Image.network(profilePictureUrl!),
                                  // ),
                                  // Or just the image if you want the original rectangular shape
                                  child: getCachedImage(
                                    imageUrl: profilePictureUrl!,
                                  )),

                              const SizedBox(height: 8),
                              // User Name
                              Text(
                                userName ?? "UserName",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Profile Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Actions
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: navigateToEditPage,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  label: const Text('Edit Profile'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Profile Information Section
                          const Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoTile(
                            icon: Icons.email,
                            title: 'Email',
                            subtitle: email ?? 'john.doe@example.com',
                          ),

                          const SizedBox(height: 24),

                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _showLogoutDialog(context),
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              label: const Text('Logout'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
