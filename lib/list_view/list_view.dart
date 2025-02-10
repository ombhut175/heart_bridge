import 'package:flutter/cupertino.dart';
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
        title: Text('User List'),
      ),
      body: userObj == null
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
                    print(snapshot.hasData);
                    print(snapshot.data);
                    return snapshot.hasData
                        ? giveListOfUsers(users: snapshot.data)
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
    );
  }

  Widget giveListOfUsers({required users}) {
    return users.length <= 0
        ? const Center(
            child: Text("No Users Found"),
          )
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          user[MyDatabase.NAME],
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                      userId: user[MyDatabase.USER_ID], index: index),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return UserEntryPage(
                          userDetails: user,
                        );
                      },
                    ));
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              );
            },
          );
    // return const Placeholder();
  }

  Widget deleteButton({required int userId, required int index}) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text("Delete User"),
                content:
                    const Text("Are you sure you want to delete this user?"),
                actions: [
                  TextButton(
                    onPressed: () async {
                      print(userId);
                      await userObj!.deleteUser(userId: userId);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  )
                ],
              );
            });
      },
      autofocus: true,
      hoverColor: Colors.blue,
      child: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }

  Widget _buildHeartIcon(bool isFavorite, {required int userId}) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: isFavorite ? Colors.red : Colors.yellow,
        size: 24,
      ),
      onPressed: () async {
        await userObj!.toggleFavourite(userId: userId);
        setState(() {});
      }, // This makes the icon non-tappable
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
