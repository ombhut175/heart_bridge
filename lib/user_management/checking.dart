import 'package:flutter/material.dart';

class Checking {
  final String id;
  final String name;
  final String mobileNumber;
  final String gender;
  final String city;

  Checking({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.gender,
    required this.city,
  });
}

class CheckingListPage extends StatefulWidget {
  const CheckingListPage({Key? key}) : super(key: key);

  @override
  _CheckingListPageState createState() => _CheckingListPageState();
}

class _CheckingListPageState extends State<CheckingListPage> {
  // Sample list of users with updated information
  List<Checking> users = [
    Checking(id: '1', name: 'John Doe', mobileNumber: '+1 123-456-7890', gender: 'Male', city: 'New York'),
    Checking(id: '2', name: 'Jane Smith', mobileNumber: '+1 234-567-8901', gender: 'Female', city: 'Los Angeles'),
    Checking(id: '3', name: 'Bob Johnson', mobileNumber: '+1 345-678-9012', gender: 'Male', city: 'Chicago'),
    // Add more users as needed
  ];

  void _deleteChecking(String userId) {
    setState(() {
      users.removeWhere((user) => user.id == userId);
    });
  }

  void _onCheckingTap(Checking user) {
    // Handle user tap
    print('Checking tapped: ${user.name}');
    // You can navigate to a user details page here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checking List'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text('Mobile: ${user.mobileNumber}'),
                  Text('Gender: ${user.gender}'),
                  Text('City: ${user.city}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteChecking(user.id),
              ),
              onTap: () => _onCheckingTap(user),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}