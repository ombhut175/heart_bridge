import 'package:flutter/material.dart';
import 'package:matrimony_app/add_edit_user/add_edit_user_screen.dart';
import 'package:matrimony_app/database/my_database.dart';
import 'package:matrimony_app/user_management/user.dart';

class UserListPage extends StatefulWidget {
  bool isFavourite;

  UserListPage({super.key, this.isFavourite = false});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> users = [];
  User? userObj;

  Future<void> initializeUser() async {
    userObj = await User.create();
  }

  

  @override
  void initState() {
    super.initState();
    initializeUser().then(
          (_) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFavourite ? 'Favorite Users' : 'User List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade700, Colors.red.shade300],
          ),
        ),
        child: userObj == null
            ? const Center(child: CircularProgressIndicator())
            : widget.isFavourite
            ? FutureBuilder(
          future: userObj!.getFavouriteUsers(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? giveListOfUsers(users: snapshot.data)
                : const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
            : FutureBuilder(
          future: userObj!.getUsers(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? giveListOfUsers(users: snapshot.data)
                : const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget giveListOfUsers({required users}) {
    return users.length <= 0
        ? Center(
      child: Text(
        "No Users Found",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    )
        : ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade200,
              child: Text(
                user[MyDatabase.NAME][0].toUpperCase(),
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    user[MyDatabase.NAME],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                _buildHeartIcon(
                  user[MyDatabase.IS_FAVOURITE] == 1,
                  userId: user[MyDatabase.USER_ID],
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 4),
                Text('Mobile: ${user[MyDatabase.MOBILE_NUMBER]}'),
                Text('Gender: ${user[MyDatabase.GENDER]}'),
                Text('City: ${user[MyDatabase.CITY]}'),
              ],
            ),
            trailing: deleteButton(
              userId: user[MyDatabase.USER_ID],
              index: index,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserEntryPage(
                      userDetails: user,
                    );
                  },
                ),
              ).then(
                    (value) async {
                  await userObj!.editUser(value);
                  setState(() {});
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget deleteButton({required int userId, required int index}) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Delete User"),
              content: Text("Are you sure you want to delete this user?"),
              actions: [
                TextButton(
                  onPressed: () async {
                    await userObj!.deleteUser(userId: userId);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeartIcon(bool isFavorite, {required int userId}) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: isFavorite ? Colors.red : Colors.grey,
        size: 24,
      ),
      onPressed: () async {
        await userObj!.toggleFavourite(userId: userId);
        setState(() {});
      },
    );
  }
}