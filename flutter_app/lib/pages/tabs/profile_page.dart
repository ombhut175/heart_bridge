import 'package:matrimony_app/utils/exports/main.dart';

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
      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setBool(IS_USER_LOGIN, false);

      if (widget.isCloudUser) {
        await postRequestForLogOut();
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (error) {
      handleErrors(context, error.toString());
    }
  }

  String? email;
  String? userName;

  Future<void> getUserNameAndEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Set values independently, even if one is null
    userName = preferences.getString(USER_NAME);
    email = preferences.getString(EMAIL);

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
        setState(() {}); // Trigger rebuild after data is fetched
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                  _buildInfoTile(
                    icon: Icons.phone,
                    title: 'Phone',
                    subtitle: '+1 234 567 890',
                  ),
                  _buildInfoTile(
                    icon: Icons.location_on,
                    title: 'Location',
                    subtitle: 'New York, USA',
                  ),
                  const SizedBox(height: 24),

                  // Settings Section
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsTile(
                    context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {
                      // Handle notifications settings
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.privacy_tip,
                    title: 'Privacy',
                    onTap: () {
                      // Handle privacy settings
                    },
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () {
                      // Handle help and support
                    },
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
