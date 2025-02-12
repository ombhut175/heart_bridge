import 'package:flutter/material.dart';
import 'package:matrimony_app/add_edit_user/add_edit_user_screen.dart';
import 'package:matrimony_app/database/my_database.dart';
import 'package:matrimony_app/user_management/user.dart';

class UserListPage extends StatefulWidget {
  final bool isFavourite;

  const UserListPage({Key? key, this.isFavourite = false}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late User userObj;
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Initialize the user object and load the initial user list.
  Future<void> _initializeUser() async {
    userObj = await User.create();
    await _loadUsers();
  }

  /// Load users (or favorite users) from the database and apply the current search filter.
  Future<void> _loadUsers() async {
    if (widget.isFavourite) {
      allUsers = await userObj.getFavouriteUsers();
    } else {
      allUsers = await userObj.getUsers();
    }
    setState(() {
      isLoading = false;
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers.where((user) {
          return user[MyDatabase.NAME]
              .toString()
              .toLowerCase()
              .contains(query) ||
              user[MyDatabase.CITY]
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              user[MyDatabase.EMAIL]
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              user[MyDatabase.MOBILE_NUMBER]
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList();
      }
    });
  }

  /// Filter the [allUsers] list based on the search query.
  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredUsers = List.from(allUsers);
      } else {
        filteredUsers = allUsers.where((user) {
          return user[MyDatabase.NAME]
              .toString()
              .toLowerCase()
              .contains(query) ||
              user[MyDatabase.CITY]
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              user[MyDatabase.EMAIL]
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              user[MyDatabase.MOBILE_NUMBER]
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFavourite ? 'Favorite Users' : 'User List',
          style: const TextStyle(color: Colors.white),
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
        child: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by name, city, email, or phone...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            // User List or Loading Indicator
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : giveListOfUsers(users: filteredUsers),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a list view of user cards.
  Widget giveListOfUsers({required List<Map<String, dynamic>> users}) {
    if (users.isEmpty) {
      return const Center(
        child: Text(
          "No Users Found",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis     ,
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
                const SizedBox(height: 4),
                Text('Mobile: ${user[MyDatabase.MOBILE_NUMBER]}'),
                Text('Gender: ${user[MyDatabase.GENDER]}'),
                Text('City: ${user[MyDatabase.CITY]}'),
              ],
            ),
            trailing: deleteButton(userId: user[MyDatabase.USER_ID]),
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
              ).then((value) async {
                if (value != null) {
                  // After editing, refresh the list.
                  await userObj.editUser(value);
                  await _loadUsers();
                }
              });
            },
          ),
        );
      },
    );
  }

  /// Build a delete button that confirms before deleting the user.
  Widget deleteButton({required int userId}) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete User"),
              content: const Text("Are you sure you want to delete this user?"),
              actions: [
                TextButton(
                  onPressed: () async {
                    await userObj.deleteUser(userId: userId);
                    Navigator.pop(context);
                    await _loadUsers();
                  },
                  child: const Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Build the heart icon button that toggles the favourite status.
  Widget _buildHeartIcon(bool isFavorite, {required int userId}) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: isFavorite ? Colors.red : Colors.grey,
        size: 24,
      ),
      onPressed: () async {
        await userObj.toggleFavourite(userId: userId);
        await _loadUsers();
      },
    );
  }
}
