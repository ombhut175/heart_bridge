import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_app/database/my_database.dart';
import 'package:matrimony_app/user_management/user.dart';
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

  Future<void> handleSubmitForm() async {
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

    User userToSubmit = await User.create();
    if(isEditPage){
      await userToSubmit.editUser(userAndHobbies);
    }else{
      await userToSubmit.addUser(userAndHobbies);
    }
    Navigator.pop(context, {});
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
          isEditPage ? "Edit Profile" : "Create Profile",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          SizedBox(height: 16),
                          inputTextField(
                            text: "Full Name",
                            controller: nameController,
                            forWhatValue: "name",
                            regxPattern: r"^[a-zA-Z\s'-]{2,50}$",
                            icon: Icons.person,
                            textInputType: TextInputType.text,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z\s]')),
                            ],
                          ),
                          inputTextField(
                            text: "Email Address",
                            controller: emailController,
                            forWhatValue: "Email",
                            regxPattern:
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            icon: Icons.email,
                            textInputType: TextInputType.emailAddress,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                          ),
                          inputTextField(
                            text: "Mobile Number",
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
                          buildGenderDropdown(),
                          buildCityDropdown(),
                          SizedBox(height: 16),
                          Text(
                            "Hobbies & Interests",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          SizedBox(height: 8),
                          buildHobbiesSection(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        // For wider screens, keep the buttons side by side
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSubmitButton(),
                            SizedBox(width: 16),
                            _buildResetButton(),
                          ],
                        );
                      } else {
                        // For narrower screens, stack the buttons vertically
                        return Column(
                          children: [
                            _buildSubmitButton(),
                            SizedBox(height: 16),
                            _buildResetButton(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
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
    IconData? icon,
    TextInputType? textInputType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
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
          prefixIcon: Icon(icon, color: Colors.red.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade700, width: 2),
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
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Colors.red.shade700,
                  colorScheme: ColorScheme.light(primary: Colors.red.shade700),
                  buttonTheme:
                      ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child!,
              );
            },
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
              borderSide: BorderSide(color: Colors.red.shade700),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade700, width: 2),
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
              Icon(Icons.calendar_today, color: Colors.red.shade700),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHobbiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: getCheckBox(),
      ),
    );
  }

  Widget buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
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
              borderSide: BorderSide(color: Colors.red.shade700),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade700, width: 2),
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
          FocusScope.of(context).unfocus();
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
              borderSide: BorderSide(color: Colors.red.shade700),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade700, width: 2),
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
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              hobbies[entry.key] = hobbies[entry.key] == 1 ? 0 : 1;
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hobbies[entry.key] == 1
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: Colors.red.shade700,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    color: hobbies[entry.key] == 1
                        ? Colors.red.shade700
                        : Colors.black87,
                    fontWeight: hobbies[entry.key] == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
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
      // _formKey.currentState?.reset();
    });
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: handleSubmitForm,
        child: Text(
          isEditPage ? "Update Profile" : "Create Profile",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.red.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
        ),
        onPressed: resetForm,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, size: 20),
            SizedBox(width: 8),
            Text(
              "Reset",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
