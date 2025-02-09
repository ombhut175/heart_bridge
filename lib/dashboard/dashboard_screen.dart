import 'package:flutter/material.dart';
import 'package:matrimony_app/about_page/about_page.dart';
import 'package:matrimony_app/add_edit_user/add_edit_user_screen.dart';
import 'package:matrimony_app/user_management/user.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> attributesList = [
    {
      "Icon": Icons.person_add,
      "Name": "Add User",
      "OnClick": (context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return UserEntryPage();
          },
        )).then(
          (value) async {
            User user = await User.create();
            await user.addUser(value);
          },
        );
        ;
      }
    },
    {"Icon": Icons.people, "Name": "User List"},
    {"Icon": Icons.favorite, "Name": "Favourite User"},
    {
      "Icon": Icons.info,
      "Name": "About Us",
      "OnClick": (context) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AboutPage();
          },
        ));
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Matrimonial App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        children: getListOfItems(),
      ),
    );
  }

  List<Widget> getListOfItems() {
    return attributesList
        .map((attribute) => getGridView(
            iconToUse: attribute["Icon"],
            name: attribute["Name"],
            onClickFunction: attribute["OnClick"]))
        .toList();
  }

  Widget getGridView(
      {required IconData iconToUse,
      required String name,
      Function? onClickFunction}) {
    return InkWell(
      onTap: () {
        onClickFunction!(context);
      },
      splashColor: Colors.red.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconToUse,
                size: 50,
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
