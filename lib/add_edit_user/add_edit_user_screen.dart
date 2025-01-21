import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimony_app/utils/string_const.dart';

class UserEntryPage extends StatefulWidget {
  Map<String, dynamic>? userDetails = {};

  UserEntryPage({super.key, this.userDetails});

  @override
  State<UserEntryPage> createState() => _UserEntryPageState();
}

class _UserEntryPageState extends State<UserEntryPage> {
  List<String> cities = ["Rajkot", "Ahmedabad", "Gujarat", "Vadodra"];
  String selectedCity = '';

  bool isEditPage = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController genderController = TextEditingController();
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

    if (isEditPage) {
      nameController.text = widget.userDetails![NAME].toString();
      emailController.text = widget.userDetails![EMAIL].toString();
      mobileNumberController.text = widget.userDetails![PHONE].toString();
      dobController.text = widget.userDetails![DOB].toString();
      cityController.text = widget.userDetails![CITY].toString();
      genderController.text = widget.userDetails![GENDER].toString();
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
          padding: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              inputTextField(
                  text: "Enter Name",
                  controller: nameController,
                  forWhatValue: "name",
                  regxPattern: r"^[a-zA-Z\s'-]{3,50}$"),
              const SizedBox(
                height: 10,
              ),
              inputTextField(
                text: "Enter Email Address",
                controller: emailController,
                forWhatValue: "Email",
                regxPattern:
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
              ),
              const SizedBox(
                height: 10,
              ),
              inputTextField(
                text: "Enter Mobile Number",
                controller: mobileNumberController,
                forWhatValue: "Mobile Number",
                regxPattern: r"^\+?[0-9]{10,15}$",
                textInputType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton<String>(
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
              const SizedBox(
                height: 10,
              ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
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
    );
  }
}
