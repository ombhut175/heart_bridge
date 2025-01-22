import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF673AB7), // Purple color
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // App Logo
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.keyboard, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Typing Tutor',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF673AB7),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Meet Our Team Section
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF673AB7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Meet Our Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: const [
                        TeamInfoRow(title: 'Developed by', value: 'John Doe (123456789)'),
                        TeamInfoRow(
                          title: 'Mentored by',
                          value: 'Prof. Jane Smith (Computer Engineering Department), School of Computer Science',
                        ),
                        TeamInfoRow(
                          title: 'Explored by',
                          value: 'ASWDC, School of Computer Science',
                        ),
                        TeamInfoRow(
                          title: 'Eulogized by',
                          value: 'Demo University, City, State - COUNTRY',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // About ASWDC Section
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF673AB7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'About ASWDC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network('https://placeholder.com/wp-content/uploads/2018/10/placeholder.com-logo1.png'),
                        const SizedBox(height: 16),
                        const Text(
                          'ASWDC is Application, Software and Website Development Center @ Demo University run by Students and Staff of School Of Computer Science.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Sole purpose of ASWDC is to bridge gap between university curriculum & industry demands. Students learn cutting edge technologies, develop real world application & experiences professional environment @ ASWDC under guidance of industry experts & faculty members.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contact Us Section
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF673AB7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Contact Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: const [
                        ContactRow(icon: Icons.email, text: 'contact@example.com'),
                        ContactRow(icon: Icons.phone, text: '+1-234-567-8900'),
                        ContactRow(icon: Icons.language, text: 'www.example.com'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  ActionButton(icon: Icons.share, text: 'Share App'),
                  Divider(height: 1),
                  ActionButton(icon: Icons.apps, text: 'More Apps'),
                  Divider(height: 1),
                  ActionButton(icon: Icons.star, text: 'Rate Us'),
                  Divider(height: 1),
                  ActionButton(icon: Icons.thumb_up, text: 'Like us on Facebook'),
                  Divider(height: 1),
                  ActionButton(icon: Icons.update, text: 'Check For Update'),
                ],
              ),
            ),

            // Footer
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '© 2025 Demo University',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'All Rights Reserved - ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Made with '),
                      Icon(Icons.favorite, color: Colors.red, size: 16),
                      Text(' in India'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TeamInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const TeamInfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$title :',
              style: const TextStyle(
                color: Color(0xFF673AB7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF673AB7)),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const ActionButton({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF673AB7)),
            const SizedBox(width: 16),
            Text(text),
          ],
        ),
      ),
    );
  }
}