import 'package:flutter/material.dart';

class BaseColor{
  static const color = Colors.blue;
}

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
        backgroundColor: BaseColor.color, // Purple color
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // App Logo
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.chat, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Matrimony App',
              style: TextStyle(
                fontSize: 24,
                color: BaseColor.color,
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
                    decoration: getBoxTitle(),
                    child: const Text(
                      'Meet Our Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TeamInfoRow(title: 'Developed by', value: 'Om Bhut (23010101033)'),
                        TeamInfoRow(
                          title: 'Mentored by',
                          value: 'Prof. Mehul Bhundiya (Faculty of Department of Computer Science and Engineering)',
                        ),
                        TeamInfoRow(
                          title: 'Explored by',
                          value: 'ASWDC, School of Computer Science',
                        ),
                        TeamInfoRow(
                          title: 'Eulogized by',
                          value: 'Darshan University, Rajkot, Gujarat - INDIA',
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
                    decoration: getBoxTitle(),
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
                        Image.asset('assests/images/aswdcLogo.png'),
                        const SizedBox(height: 16),
                        const Text(
                          'ASWDC is Application, Software and Website Development Center @ Darshan University run by Students and Staff of School Of Computer Science.',
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
                    decoration: getBoxTitle(),
                    child: const Text(
                      'Contact Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ContactRow(icon: Icons.email, text: 'aswdc@darshan.ac.in'),
                        ContactRow(icon: Icons.phone, text: '+91-9727747317'),
                        ContactRow(icon: Icons.language, text: 'www.darshan.ac.in'),
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
              child: const Column(
                children: [
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
                    '© 2025 Darshan University',
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
  BoxDecoration getBoxTitle(){
      return  const BoxDecoration(
        color: BaseColor.color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
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
                color: BaseColor.color,
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
          Icon(icon, color: BaseColor.color),
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
            Icon(icon, color: BaseColor.color),
            const SizedBox(width: 16),
            Text(text),
          ],
        ),
      ),
    );
  }
}