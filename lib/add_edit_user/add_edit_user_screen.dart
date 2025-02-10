import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_app/database/my_database.dart';
import 'package:sqflite/sqflite.dart';

class UserEntryPage extends StatefulWidget {
  Map<String, dynamic>? userDetails = {};

  UserEntryPage({super.key, this.userDetails});

  @override
  State<UserEntryPage> createState() => _UserEntryPageState();
}

class _UserEntryPageState extends State<UserEntryPage> {
  List<String> cities = ["Rajkot", "Ahmedabad", "Bhavnagar", "Vadodra"];
  List<String> genders = ["Male", "Female", "Other"];
  Map<String, int> hobbies = {};

  Map<int, String> categoryHobbyMap = {
    1: 'Sports',
    2: 'Video gaming',
    3: 'Book Reading',
    4: 'Music',
    5: 'DHH',
  };

  String selectedCity = '';

  bool isEditPage = false;

  String selectedGender = 'Male';

  DateTime? date;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController hobbiesController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  void handleSubmitForm() {
    print("from handleSubmitForm");
    if (!_formKey.currentState!.validate()) {
      print("Form is invalid. Please correct errors.");
      return;
    }
    Map<String, dynamic> user = {};
    user[MyDatabase.NAME] = nameController.text.toString();
    user[MyDatabase.EMAIL] = emailController.text.toString();
    user[MyDatabase.MOBILE_NUMBER] =
        int.parse(mobileNumberController.text.toString());
    user[MyDatabase.DOB] = DateFormat("dd MMM yyyy").format(date!);
    user[MyDatabase.GENDER] = selectedGender.toString();
    user[MyDatabase.CITY] = selectedCity.toString();

    if (isEditPage) {
      user[MyDatabase.USER_ID] = widget.userDetails![MyDatabase.USER_ID];
    }
    Map<String, dynamic> userAndHobbies = {};
    userAndHobbies[MyDatabase.TBL_USER] = user;
    userAndHobbies[MyDatabase.TBL_USER_HOBBIES] = hobbies;
    userAndHobbies["isEditPage"] = isEditPage;

    print(userAndHobbies["isEditPage"]);

    Navigator.pop(context, userAndHobbies);
  }

  Future<void> getHobbies() async {
    List<Map<String, dynamic>> hobbyNames = [];
    Database db = await MyDatabase().initDatabase();
    hobbyNames = await db.query(MyDatabase.TBL_HOBBIES);
    print(hobbyNames);
    for (var hobby in hobbyNames) {
      hobbies[hobby[MyDatabase.HOBBY_NAME]] = 0;
    }
  }

  Future<void> getUserHobbiesOnEdit() async {
    print("from getUserHobbiesOnEdit");
    Database db = await MyDatabase().initDatabase();
    List<Map<String, dynamic>> userHobbies = await db.query(
        MyDatabase.TBL_USER_HOBBIES,
        where: "${MyDatabase.USER_ID} = ?",
        whereArgs: [widget.userDetails![MyDatabase.USER_ID]]);

    for (var hobby in userHobbies) {
      print(categoryHobbyMap[hobby[MyDatabase.HOBBY_ID]]);
      hobbies[categoryHobbyMap[hobby[MyDatabase.HOBBY_ID]]!] = 1;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    dobController.dispose();
    cityController.dispose();
    hobbiesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isEditPage = widget.userDetails != null;

    getHobbies().then(
      (_) {
        setState(() {});
      },
    );
    selectedCity = isEditPage
        ? widget.userDetails![MyDatabase.CITY].toString()
        : cities[0];

    date = isEditPage
        ? DateFormat('dd MMM yyyy').parse(widget.userDetails![MyDatabase.DOB])
        : DateTime(DateTime.now().year - 18);

    selectedGender =
        isEditPage ? widget.userDetails![MyDatabase.GENDER] : genders[0];

    if (isEditPage) {
      nameController.text = widget.userDetails![MyDatabase.NAME].toString();
      emailController.text = widget.userDetails![MyDatabase.EMAIL].toString();
      mobileNumberController.text =
          widget.userDetails![MyDatabase.MOBILE_NUMBER].toString();
      dobController.text = widget.userDetails![MyDatabase.DOB].toString();
      cityController.text = widget.userDetails![MyDatabase.CITY].toString();
      getUserHobbiesOnEdit().then(
        (value) {
          setState(() {});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditPage ? "Edit User" : "Add New User",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          inputTextField(
                            text: "Enter Name",
                            controller: nameController,
                            forWhatValue: "name",
                            regxPattern: r"^[a-zA-Z\s'-]{2,50}$",
                            icon: Icons.person,
                          ),
                          inputTextField(
                            text: "Enter Email Address",
                            controller: emailController,
                            forWhatValue: "Email",
                            regxPattern:
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            icon: Icons.email,
                          ),
                          inputTextField(
                            text: "Enter Mobile Number",
                            controller: mobileNumberController,
                            forWhatValue: "Mobile Number",
                            regxPattern: r"^\+?[0-9]{10,15}$",
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            icon: Icons.phone,
                            maxLength: 10,
                          ),
                          buildDatePicker(),
                          buildHobbiesSection(),
                          buildGenderDropdown(),
                          buildCityDropdown(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: handleSubmitForm,
                        child: Text(
                          isEditPage ? "Update" : "Submit",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: resetForm,
                        child: const Text(
                          "Reset",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputTextField(
      {required String text,
      TextEditingController? controller,
      String? forWhatValue,
      String? regxPattern,
      IconData? icon,
      TextInputType? textInputType,
      List<TextInputFormatter>? inputFormatters,
      int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Valid $forWhatValue';
          }
          if (!RegExp(regxPattern ?? '').hasMatch(value)) {
            return 'Enter Valid $forWhatValue';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          labelText: text,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: textInputType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
      ),
    );
  }

  Widget buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          DateTime today = DateTime.now();
          DateTime lastValidDate = DateTime(
            today.year - 18,
            today.month,
            today.day,
          );

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: date ?? lastValidDate,
            firstDate: DateTime(today.year - 80),
            lastDate: lastValidDate,
          );

          if (pickedDate != null) {
            setState(() {
              date = pickedDate;
              dobController.text = DateFormat('dd MMM yyyy').format(pickedDate);
            });
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date != null
                    ? DateFormat('dd MMM yyyy').format(date!)
                    : 'Select Date',
                style: TextStyle(fontSize: 16),
              ),
              Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHobbiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hobbies",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 0.0,
            children: getCheckBox(),
          ),
        ],
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: DropdownButtonFormField<String>(
          value: selectedGender,
          items: genders.map((gender) {
            return DropdownMenuItem(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGender = value.toString();
            });
          },
          decoration: InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildCityDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: DropdownButtonFormField<String>(
          value: selectedCity,
          items: cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCity = value.toString();
            });
          },
          decoration: InputDecoration(
            labelText: 'City',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  List<Widget> getCheckBox() {
    return hobbies.entries.map((entry) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: entry.value == 1,
              onChanged: (bool? value) {
                setState(() {
                  hobbies[entry.key] = value! ? 1 : 0;
                });
              },
            ),
            Flexible(
              child: Text(
                entry.key,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void resetForm() {
    setState(() {
      // Reset text controllers
      nameController.clear();
      emailController.clear();
      mobileNumberController.clear();
      dobController.clear();
      cityController.clear();
      hobbiesController.clear();

      // Reset dropdown selections
      selectedCity = cities[0];
      selectedGender = genders[0];

      // Reset date to 18 years ago
      date = DateTime(DateTime.now().year - 18);

      // Reset all hobbies to false
      hobbies.forEach((key, value) {
        hobbies[key] = 0;
      });

      // Reset form validation state
      _formKey.currentState?.reset();
    });
  }
}
