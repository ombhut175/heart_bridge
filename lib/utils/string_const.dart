const String NAME = 'Name';
const String EMAIL = 'Email';
const String PHONE = 'Phone';
const String DOB = 'Date of birth';
const String CITY = 'City';
const String AGE = 'Age';
const String GENDER = 'Gender';
const String PASSWORD = 'Password';

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printResultText(String text) {
  print('\x1B[31m$text\x1B[0m');
}
