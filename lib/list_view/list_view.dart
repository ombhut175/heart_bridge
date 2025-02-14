import 'package:flutter/material.dart';
import 'package:matrimony_app/add_edit_user/add_edit_user_screen.dart';
import 'package:matrimony_app/database/my_database.dart';
import 'package:matrimony_app/user_management/user.dart';

class UserListPage extends StatefulWidget {
  final bool isFavourite;

  const UserListPage({Key? key, this.isFavourite = false}) : super(key: key);

  @override
  State<UserListPage> createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  late User userObj;
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  /// Future to track the initialization process.
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeUser();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeUser() async {
    userObj = await User.create();
    await loadUsers();
  }

  Future<void> loadUsers() async {
    if (widget.isFavourite) {
      allUsers = await userObj.getFavouriteUsers();
    } else {
      allUsers = await userObj.getUsers();
    }
    _filterUsers();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      isLoading = false;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !widget.isFavourite,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20), // Increased bottom margin
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return UserEntryPage();
                },
              )).then(
                    (value) async {
                  loadUsers();
                },
              );
            },
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 4,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: Text(
          widget.isFavourite ? 'Favorite Users' : 'User List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildUserList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserList() {
    if (filteredUsers.isEmpty) {
      return Center(
        child: Text(
          "No Users Found",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _editUser(user),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      user[MyDatabase.NAME][0].toUpperCase(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.person, user[MyDatabase.NAME], isBold: true),
                        SizedBox(height: 4),
                        _buildInfoRow(Icons.location_city, user[MyDatabase.CITY]),
                        SizedBox(height: 4),
                        _buildInfoRow(Icons.phone, user[MyDatabase.MOBILE_NUMBER].toString()),
                        SizedBox(height: 4),
                        _buildInfoRow(Icons.person_outline, user[MyDatabase.GENDER]),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(height: 1, thickness: 1),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFavoriteButton(user),
                  _buildDeleteButton(user),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).primaryColor),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.black87 : Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(Map<String, dynamic> user) {
    return TextButton.icon(
      icon: Icon(
        user[MyDatabase.IS_FAVOURITE] == 1 ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).colorScheme.secondary,
      ),
      label: Text('Favorite'),
      onPressed: () async {
        await userObj.toggleFavourite(userId: user[MyDatabase.USER_ID]);
        await loadUsers();
      },
    );
  }

  Widget _buildDeleteButton(Map<String, dynamic> user) {
    return TextButton.icon(
      icon: Icon(Icons.delete_outline, color: Colors.red),
      label: Text('Delete', style: TextStyle(color: Colors.red)),
      onPressed: () => _showDeleteConfirmation(user),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete User"),
        content: Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await userObj.deleteUser(userId: user[MyDatabase.USER_ID]);
              Navigator.pop(context);
              await loadUsers();
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editUser(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserEntryPage(userDetails: user),
      ),
    ).then((value) async {
      setState(() {
        loadUsers();
      });
    });
  }
}

