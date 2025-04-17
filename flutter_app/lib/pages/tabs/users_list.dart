import 'package:matrimony_app/utils/exports/main.dart';

class UserListPage extends StatefulWidget {
  final bool isFavourite;
  final bool isCloudUser;

  UserListPage({Key? key, this.isFavourite = false, this.isCloudUser = false})
      : super(key: key);

  @override
  State<UserListPage> createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  late User userObj;
  late final UserProvider userProvider;
  late UserApiService userApiService;
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
    if (widget.isCloudUser) {
      userApiService = UserApiService();
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await loadUsersUsingApi();
    } else {
      userObj = await User.create();
      await loadUsers();
    }
  }

  Future<void> loadUsers() async {
    if (widget.isFavourite) {
      allUsers = await userObj.getFavouriteUsers();
    } else {
      allUsers = await userObj.getUsers();
    }
    _filterUsers();
  }

  Future<void> loadUsersUsingApi() async {
    try {
      if (widget.isFavourite) {
        await userProvider.fetchFavouriteUsers(context: context);

        allUsers = userProvider.favUsers ?? [];
      } else {
        await userProvider.fetchUsers(context: context);

        allUsers = userProvider.users ?? [];
      }

      _filterUsers();
    } catch (error) {
      handleErrors(context, error.toString());
    }
  }

  Future<void> handleDeleteUser(dynamic user) async {
    if (widget.isCloudUser) {
      print(user);
      // await userApiService.deleteUser(userId: user[USER_ID], context: context);

      await userProvider.deleteUser(context: context, userId: user[USER_ID]);

      Navigator.pop(context);

      await loadUsersUsingApi();
    } else {
      await userObj.deleteUser(userId: user[USER_ID]);

      Navigator.pop(context);

      await loadUsers();
    }
  }

  Map<String, dynamic> activeFilters = {
    'gender': null,
    'city': null,
    'hobbies': <String>[],
  };

  // Add this method to get unique cities from users
  List<String> get uniqueCities {
    return allUsers.map((user) => user[CITY].toString()).toSet().toList()
      ..sort();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      isLoading = false;
      filteredUsers = allUsers.where((user) {
        bool matchesSearch =
            user[NAME].toString().toLowerCase().contains(query) ||
                user[CITY].toString().toLowerCase().contains(query) ||
                user[EMAIL].toString().toLowerCase().contains(query) ||
                user[MOBILE_NUMBER].toString().toLowerCase().contains(query);

        // Apply filters
        bool matchesFilters = true;
        if (activeFilters['gender'] != null) {
          matchesFilters &= user[GENDER] == activeFilters['gender'];
        }
        if (activeFilters['city'] != null) {
          matchesFilters &= user[CITY] == activeFilters['city'];
        }
        // if (activeFilters['hobbies'].isNotEmpty) {
        //   List<String> userHobbies = (user[HOBBIES] ?? '').toString().split(',');
        //   matchesFilters &= activeFilters['hobbies'].any((hobby) => userHobbies.contains(hobby));
        // }

        return matchesSearch && matchesFilters;
      }).toList();
    });
  }

  Future<void> handleToggleFavourite(dynamic user) async {
    print("::: from handle toggle favourite");
    print(user);
    if (widget.isCloudUser) {
      // await userApiService.toggleFavourite(userId: user[USER_ID], context: context);

      await userProvider.toggleFavourite(
          context: context, userId: user[USER_ID]);
      await loadUsersUsingApi();
    } else {
      await userObj.toggleFavourite(userId: user[USER_ID]);
      await loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Scaffold(
        floatingActionButton: Visibility(
          visible: !widget.isFavourite,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            // Increased bottom margin
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UserEntryPage(
                      isCloudUser: widget.isCloudUser,
                    );
                  },
                )).then(
                  (value) async {
                    widget.isCloudUser ? loadUsersUsingApi() : loadUsers();
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
                  child: Row(
                    children: [
                      Expanded(
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
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.filter_list, color: Colors.white),
                          onPressed: _showFilterModal,
                          tooltip: 'Filter',
                        ),
                      ),
                    ],
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
                      user[NAME][0].toUpperCase(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.person, user[NAME], isBold: true),
                        SizedBox(height: 4),
                        _buildInfoRow(Icons.location_city, user[CITY]),
                        SizedBox(height: 4),
                        _buildInfoRow(
                            Icons.phone, user[MOBILE_NUMBER].toString()),
                        SizedBox(height: 4),
                        _buildInfoRow(Icons.person_outline, user[GENDER]),
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
        user[IS_FAVOURITE] == 1 ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).colorScheme.secondary,
      ),
      label: Text('Favorite'),
      onPressed: () async {
        await handleToggleFavourite(user);
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
              await handleDeleteUser(user);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editUser(Map<String, dynamic> user) {
    print("::: from edit user :::");
    print(user[USER_ID]);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserEntryPage(
          userDetails: user,
          isCloudUser: widget.isCloudUser,
        ),
      ),
    ).then((value) async {
      setState(() {
        widget.isCloudUser ? loadUsersUsingApi() : loadUsers();
      });
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_list, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Filter Users',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Filter Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gender Filter
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: ['Male', 'Female', 'Other'].map((gender) {
                            bool isSelected = activeFilters['gender'] == gender;
                            return FilterChip(
                              label: Text(gender),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  activeFilters['gender'] =
                                      selected ? gender : null;
                                });
                              },
                              selectedColor:
                                  Theme.of(context).colorScheme.secondary,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16),

                        // City Filter
                        Text(
                          'City',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: activeFilters['city'],
                            hint: Text('Select City'),
                            isExpanded: true,
                            underline: SizedBox(),
                            items: [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text('All Cities'),
                              ),
                              ...uniqueCities.map((city) {
                                return DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                activeFilters['city'] = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 16),

                        // Hobbies Filter
                        // Text(
                        //   'Hobbies',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // SizedBox(height: 8),
                        // Wrap(
                        //   spacing: 8,
                        //   children: [
                        //     'Reading',
                        //     'Travel',
                        //     'Music',
                        //     'Sports',
                        //     'Cooking',
                        //     'Gaming'
                        //   ].map((hobby) {
                        //     bool isSelected =
                        //         activeFilters['hobbies'].contains(hobby);
                        //     return FilterChip(
                        //       label: Text(hobby),
                        //       selected: isSelected,
                        //       onSelected: (selected) {
                        //         setState(() {
                        //           if (selected) {
                        //             activeFilters['hobbies'].add(hobby);
                        //           } else {
                        //             activeFilters['hobbies'].remove(hobby);
                        //           }
                        //         });
                        //       },
                        //       selectedColor:
                        //           Theme.of(context).colorScheme.secondary,
                        //       checkmarkColor: Colors.white,
                        //       labelStyle: TextStyle(
                        //         color: isSelected ? Colors.white : Colors.black,
                        //       ),
                        //     );
                        //   }).toList(),
                        // ),
                      ],
                    ),
                  ),
                ),

                // Action Buttons
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              activeFilters = {
                                'gender': null,
                                'city': null,
                                'hobbies': <String>[],
                              };
                            });
                          },
                          child: Text('Reset'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _filterUsers();
                          },
                          child: Text('Apply Filters'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
