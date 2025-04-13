import 'package:intl/intl.dart';
import 'package:matrimony_app/utils/exports/main.dart';

class UserEntryPage extends StatefulWidget {
  final Map<String, dynamic>? userDetails;
  final bool isCloudUser;

  const UserEntryPage({Key? key, this.userDetails, this.isCloudUser = false})
      : super(key: key);

  @override
  State<UserEntryPage> createState() => _UserEntryPageState();
}

class _UserEntryPageState extends State<UserEntryPage> {
  final List<String> cities = ["Rajkot", "Ahmedabad", "Bhavnagar", "Vadodra"];
  final List<String> genders = ["Male", "Female", "Other"];
  Map<String, int> hobbies = Map.from(Services.hobbies);

  final Map<int, String> categoryHobbyMap = Services.categoryHobbyMap;

  late String selectedCity;
  late String selectedGender;
  late DateTime? date;

  bool isEditPage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController hobbiesController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _UserEntryPageState() : isEditPage = false;

  Future<void> setUserHobbiesOnEdit() async {
    if (widget.isCloudUser) {
      for (String i in widget.userDetails![HOBBIES]) {
        hobbies[i] = 1;
      }
    } else {
      await getUserHobbiesOnEdit();
    }
  }

  @override
  void initState() {
    super.initState();
    isEditPage = widget.userDetails != null;

    print("::: from init state of add edit user");
    print(widget.userDetails);

    // getHobbies().then((_) => setState(() {}));

    if (!widget.isCloudUser) {
      Services.getHobbies().then(
        (value) {
          setState(() {
            hobbies = value;
          });
        },
      );
    }
    selectedCity =
        isEditPage ? widget.userDetails![CITY].toString() : cities[0];

    date = isEditPage
        ? DateFormat('dd MMM yyyy').parse(widget.userDetails![DOB])
        : DateTime(DateTime.now().year - 18);

    selectedGender =
        isEditPage ? widget.userDetails![GENDER] ?? "Male" : genders[0];

    if (isEditPage) {
      nameController.text = widget.userDetails![NAME].toString();
      emailController.text = widget.userDetails![EMAIL].toString();
      mobileNumberController.text =
          widget.userDetails![MOBILE_NUMBER].toString() ?? "94548488";
      dobController.text = widget.userDetails![DOB].toString();
      cityController.text = widget.userDetails![CITY].toString();
      // getUserHobbiesOnEdit().then((_) => setState(() {}));

      setUserHobbiesOnEdit().then(
        (_) => setState(() {}),
      );
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

  Future<void> handleSubmitFormForApi() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please correct the errors in the form.")),
      );
      return;
    }

    print("::: from api submit :::");

    try {
      // UserApiService userApiService = UserApiService();
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      String adminEmail = await Services.getUserEmailFromSharedPreferences();

      // String date = DateFormat("dd MMM yyyy").format(date!);

      Map<String, dynamic> user = {
        NAME: nameController.text,
        EMAIL: emailController.text,
        MOBILE_NUMBER: int.parse(mobileNumberController.text),
        DOB: DateFormat("dd MMM yyyy").format(date!),
        GENDER: selectedGender,
        CITY: selectedCity,
        ADMIN_EMAIL: adminEmail
      };
      List<String> hobbiesList = [];

      hobbies.forEach(
        (key, value) {
          if (value == 1) {
            hobbiesList.add(key);
          }
        },
      );

      user[HOBBIES] = hobbiesList;

      if (isEditPage) {
        user[USER_ID] = widget.userDetails![USER_ID];
        // await userApiService.updateUser(user: user, context: context);

        await userProvider.updateUser(context: context, user: user);
      } else {
        // await userApiService.addUser(user: user, context: context);
        await userProvider.addUser(context: context, user: user);
      }

      Navigator.pop(context, {});
    } catch (error) {
      handleErrors(context, error.toString());
    }
  }

  Future<void> handleSubmitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please correct the errors in the form.")),
      );
      return;
    }

    Map<String, dynamic> user = {
      NAME: nameController.text,
      EMAIL: emailController.text,
      MOBILE_NUMBER: int.parse(mobileNumberController.text),
      DOB: DateFormat("dd MMM yyyy").format(date!),
      GENDER: selectedGender,
      CITY: selectedCity,
    };

    if (isEditPage) {
      user[USER_ID] = widget.userDetails![USER_ID];
    }

    Map<String, dynamic> userAndHobbies = {
      MyDatabase.TBL_USER: user,
      MyDatabase.TBL_USER_HOBBIES: hobbies,
      IS_EDIT_PAGE: isEditPage,
    };

    User userToSubmit = await User.create();
    if (isEditPage) {
      await userToSubmit.editUser(userAndHobbies);
    } else {
      await userToSubmit.addUser(userAndHobbies);
    }

    Navigator.pop(context, {});
  }

  Future<void> getHobbies() async {
    Database db = await MyDatabase().initDatabase();
    List<Map<String, dynamic>> hobbyNames =
        await db.query(MyDatabase.TBL_HOBBIES);
    for (var hobby in hobbyNames) {
      hobbies[hobby[MyDatabase.HOBBY_NAME]] = 0;
    }
  }

  Future<void> getUserHobbiesOnEdit() async {
    Database db = await MyDatabase().initDatabase();
    List<Map<String, dynamic>> userHobbies = await db.query(
      MyDatabase.TBL_USER_HOBBIES,
      where: "${USER_ID} = ?",
      whereArgs: [widget.userDetails![USER_ID]],
    );

    for (var hobby in userHobbies) {
      hobbies[categoryHobbyMap[hobby[MyDatabase.HOBBY_ID]]!] = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditPage ? "Edit Profile" : "Create Profile",
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE91E63),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE91E63), Color(0xFFFFC107)],
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildPersonalInfoCard(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              text: "Full Name",
              controller: nameController,
              forWhatValue: "name",
              regxPattern: r"^[a-zA-Z\s'-]{2,50}$",
              icon: Icons.person,
              textInputType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
              ],
            ),
            _buildTextField(
              text: "Email Address",
              controller: emailController,
              forWhatValue: "Email",
              regxPattern: r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
              icon: Icons.email,
              textInputType: TextInputType.emailAddress,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s'))
              ],
            ),
            _buildTextField(
              text: "Mobile Number",
              controller: mobileNumberController,
              forWhatValue: "Mobile Number",
              regxPattern: r"^\+?[0-9]{10,15}$",
              textInputType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              icon: Icons.phone,
              maxLength: 10,
            ),
            _buildDatePicker(),
            _buildDropdown(
              value: selectedGender,
              items: genders,
              onChanged: (value) => setState(() => selectedGender = value!),
              labelText: 'Gender',
            ),
            _buildDropdown(
              value: selectedCity,
              items: cities,
              onChanged: (value) => setState(() => selectedCity = value!),
              labelText: 'City',
            ),
            const SizedBox(height: 16),
            Text(
              "Hobbies & Interests",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildHobbiesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String text,
    required TextEditingController controller,
    required String forWhatValue,
    required String regxPattern,
    required IconData icon,
    required TextInputType textInputType,
    required List<TextInputFormatter> inputFormatters,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $forWhatValue';
          }
          if (!RegExp(regxPattern).hasMatch(value)) {
            return 'Please enter a valid $forWhatValue';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
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

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          final DateTime today = DateTime.now();
          final DateTime lastValidDate =
              DateTime(today.year - 18, today.month, today.day);

          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: date ?? lastValidDate,
            firstDate: DateTime(today.year - 80),
            lastDate: lastValidDate,
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                      primary: Theme.of(context).primaryColor),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
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
                style: const TextStyle(fontSize: 16),
              ),
              Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHobbiesSection() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: hobbies.entries.map((entry) {
        return FilterChip(
          label: Text(entry.key),
          selected: entry.value == 1,
          onSelected: (bool selected) {
            setState(() {
              hobbies[entry.key] = selected ? 1 : 0;
            });
          },
          selectedColor: Theme.of(context).colorScheme.secondary,
          checkmarkColor: Colors.white,
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed:
                widget.isCloudUser ? handleSubmitFormForApi : handleSubmitForm,
            child: Text(
              isEditPage ? "Update Profile" : "Create Profile",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              side: BorderSide(color: Theme.of(context).primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: resetForm,
            child: const Text(
              "Reset",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void resetForm() {
    setState(() {
      nameController.clear();
      emailController.clear();
      mobileNumberController.clear();
      dobController.clear();
      cityController.clear();
      hobbiesController.clear();

      selectedCity = cities[0];
      selectedGender = genders[0];
      date = DateTime(DateTime.now().year - 18);

      hobbies.forEach((key, value) {
        hobbies[key] = 0;
      });
    });
  }
}
