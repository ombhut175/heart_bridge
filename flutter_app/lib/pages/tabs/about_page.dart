import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text('About Us', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor, primaryColor.withOpacity(0.7)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // App Logo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite, size: 50, color: primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Matrimony App',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sections
              _buildSection(context, 'Meet Our Team', [
                _buildInfoRow(context, 'Developed by', 'Om Bhut (23010101033)'),
                _buildInfoRow(context, 'Mentored by',
                    'Prof. Mehul Bhundiya (Faculty of Department of Computer Science and Engineering)'),
                _buildInfoRow(context, 'Explored by', 'ASWDC, School of Computer Science'),
                _buildInfoRow(context, 'Eulogized by', 'Darshan University, Rajkot, Gujarat - INDIA'),
              ]),
              _buildSection(context, 'About ASWDC', [
                Image.asset('assets/images/aswdcLogo.png'),
                const SizedBox(height: 16),
                const Text(
                  'ASWDC is Application, Software and Website Development Center @ Darshan University run by Students and Staff of School Of Computer Science.',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sole purpose of ASWDC is to bridge gap between university curriculum & industry demands. '
                      'Students learn cutting edge technologies, develop real world application & experiences '
                      'professional environment @ ASWDC under guidance of industry experts & faculty members.',
                ),
              ]),
              _buildSection(context, 'Contact Us', [
                _buildContactRow(context, Icons.email, 'aswdc@darshan.ac.in'),
                _buildContactRow(context, Icons.phone, '+91-9727747317'),
                _buildContactRow(context, Icons.language, 'www.darshan.ac.in'),
              ]),

              // Action Buttons
              _buildActionButtons(context),

              // Footer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '© 2025 Darshan University',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'All Rights Reserved - ',
                          style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Made with ', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                        Icon(Icons.favorite, color: secondaryColor, size: 16),
                        Text(' in India', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Builds a titled "section" with a colored header and content
  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              border: const Border(
                bottom: BorderSide(
                  color: Colors.white,  // Add a white border
                  width: 2.0,  // Border width
                ),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Rest of the section content remains the same
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // Builds an information row (e.g., "Developed by: John Doe")
  Widget _buildInfoRow(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$title :',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // Builds a row for contact information (icon + text)
  Widget _buildContactRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  // Builds the container that holds all the action buttons
  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Container(
      margin: const EdgeInsets.all(16),
      // Make the background transparent (instead of white) so
      // the pink gradient behind the buttons is visible.
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.9), // <-- Removed to eliminate white background
        color: Colors.transparent, // Transparent background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionButton(context, Icons.share, 'Share App'),
          const Divider(height: 1),
          _buildActionButton(context, Icons.apps, 'More Apps'),
          const Divider(height: 1),
          _buildActionButton(context, Icons.star, 'Rate Us'),
          const Divider(height: 1),
          _buildActionButton(context, Icons.thumb_up, 'Like us on Facebook'),
          const Divider(height: 1),
          _buildActionButton(context, Icons.update, 'Check For Update'),
        ],
      ),
    );
  }

  // Builds an individual action button (icon + text)
  Widget _buildActionButton(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor, // Button background color
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
