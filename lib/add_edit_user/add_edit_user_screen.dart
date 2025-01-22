import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_app/utils/string_const.dart';

class UserEntryPage extends StatefulWidget {
  Map<String, dynamic>? userDetails = {};

  UserEntryPage({super.key, this.userDetails});

  @override
  State<UserEntryPage> createState() => _UserEntryPageState();
}

class _UserEntryPageState extends State<UserEntryPage> {
  List<String> cities = ["Rajkot", "Ahmedabad", "Gujarat", "Vadodra"];
  List<String> genders = ["Male", "Female", "Other"];
  Map<String, bool> hobbies = {
    "Cricket": false,
    "Hockey": false,
    "Singing": false
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
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    isEditPage = widget.userDetails != null;

    selectedCity =
        isEditPage ? widget.userDetails![CITY].toString() : cities[0];

    date = isEditPage
        ? widget.userDetails![DOB]
        : DateTime(DateTime.now().year - 18);

    selectedGender = isEditPage ? widget.userDetails![GENDER] : genders[0];

    if (isEditPage) {
      nameController.text = widget.userDetails![NAME].toString();
      emailController.text = widget.userDetails![EMAIL].toString();
      mobileNumberController.text = widget.userDetails![PHONE].toString();
      dobController.text = widget.userDetails![DOB].toString();
      cityController.text = widget.userDetails![CITY].toString();
      passwordController.text = widget.userDetails![PASSWORD].toString();
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
      body: Form(
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

                      date = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(today.year - 80),
                        lastDate: lastValidDate,
                      );

                      setState(() {});
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
                    const SizedBox(width: 20), // Spacing between text and checkboxes
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



              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(200, 60),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          print("Form is invalid. Please correct errors.");
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
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
              )
            ],
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
                value: entry.value,
                onChanged: (value) {
                  setState(() {
                    hobbies[entry.key] = !hobbies[entry.key]!;
                  });
                },
              ),
              Flexible(
                child: Text(
                  entry.key,
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
      passwordController.clear();
      confirmPasswordController.clear();

      // Reset dropdown selections
      selectedCity = cities[0];
      selectedGender = genders[0];

      // Reset date to 18 years ago
      date = DateTime(DateTime.now().year - 18);

      // Reset all hobbies to false
      hobbies.forEach((key, value) {
        hobbies[key] = false;
      });

      // Reset form validation state
      _formKey.currentState?.reset();
    });
  }
}
