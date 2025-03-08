const String NAME = 'Name';
const String EMAIL = 'email';
const String PHONE = 'Phone';
const String DOB = 'Date of birth';
const String CITY = 'City';
const String AGE = 'Age';
const String GENDER = 'Gender';
const String PASSWORD = 'password';
const String IS_USER_LOGIN = 'IsUserLoggedIn';
const String USER_NAME = "username";
const String BACKEND_URL = "BACKEND_URL";
const String MESSAGE = "message";
const String SUCCESS = "success";
const String SIGN_UP = "signup";
const String FORGOT_PASSWORD = "forgotPassword";
const String BODY = "body";
const String VERIFICATION_TYPE = "verificationType";
const String OTP = "otp";




void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printResultText(String text) {
  print('\x1B[31m$text\x1B[0m');
}

void printError(dynamic message) {
  print('\x1B[31m[ERROR]: $message\x1B[0m');
}