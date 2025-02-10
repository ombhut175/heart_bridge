import 'package:flutter/cupertino.dart';
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
  List<String> cities = ["Rajkot", "Ahmedabad", "Gujarat", "Vadodra"];
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

    if(isEditPage){
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
          isEditPage ? "Edit User Form" : "Registration",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: [
                inputTextField(
                    text: "Enter Name",
                    controller: nameController,
                    forWhatValue: "name",
                    regxPattern: r"^[a-zA-Z\s'-]{3,50}$"),
                inputTextField(
                  text: "Enter Email Address",
                  controller: emailController,
                  forWhatValue: "Email",
                  regxPattern:
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                ),
                inputTextField(
                  text: "Enter Mobile Number",
                  controller: mobileNumberController,
                  forWhatValue: "Mobile Number",
                  regxPattern: r"^\+?[0-9]{10,15}$",
                  textInputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                //Date Picker
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                        onTap: () async {
                          DateTime today = DateTime.now();
                          DateTime lastValidDate = DateTime(
                            today.year - 18,
                            today.month,
                            today.day,
                          );

                          // Use a temporary variable to hold the picked date.
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: date ?? lastValidDate, // Use a default if date is null.
                            firstDate: DateTime(today.year - 80),
                            lastDate: lastValidDate,
                          );

                          // Only update the state if a date was picked.
                          if (pickedDate != null) {
                            setState(() {
                              date = pickedDate;
                              dobController.text = DateFormat('dd MMM yyyy').format(pickedDate);
                            });
                          }
                        },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat('dd MMM yyyy').format(date!),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //Hobbies
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Hobbies text
                      Container(
                        padding: const EdgeInsets.only(top: 8),
                        child: const Text(
                          "Hobbies",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Spacing between text and checkboxes
                      // Right side - Wrapped checkboxes
                      Expanded(
                        child: Wrap(
                          spacing: 8.0, // Horizontal spacing between checkboxes
                          runSpacing: 0.0, // Vertical spacing between rows
                          children: getCheckBox(),
                        ),
                      ),
                    ],
                  ),
                ),

                //Gender
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                      value: selectedGender,
                      items: genders.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value.toString();
                        });
                      }),
                ),

                //City
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                      value: selectedCity,
                      items: cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value.toString();
                        });
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(200, 60),
                          ),
                          onPressed: handleSubmitForm,
                          child: Text(
                            isEditPage ? "Edit" : "Submit",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            minimumSize: const Size(200, 60),
                          ),
                          onPressed: resetForm,
                          child: const Text(
                            "Reset",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputTextField({
    required String text,
    TextEditingController? controller,
    String? forWhatValue,
    String? regxPattern,
    Icon? iconForValues,
    Color? fillColor,
    TextInputType? textInputType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      children: [
        // const SizedBox(
        //   height: 10,
        // ),
        Padding(
          padding: const EdgeInsets.all(15),
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
              suffixIcon: Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: iconForValues,
              ),
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            keyboardType: textInputType,
            inputFormatters: inputFormatters,
          ),
        ),
        // const SizedBox(
        //   height: 10,
        // ),
      ],
    );
  }

  List<Widget> getCheckBox() {
    List<Widget> checkBoxes = [];

    for (var entry in hobbies.entries) {
      checkBoxes.add(
        SizedBox(
          width: 120, // Fixed width for each checkbox item
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: entry.value == 1,
                onChanged: (value) {
                  setState(() {
                    hobbies[entry.key] = hobbies[entry.key] == 1 ? 0 : 1;
                  });
                },
              ),
              Flexible(
                child: Text(
                  entry.key.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return checkBoxes;
  }

  // Add this method to your _UserEntryPageState class
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
