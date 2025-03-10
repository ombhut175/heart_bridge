const String NAME = 'fullName';
const String EMAIL = 'email';
const String PHONE = 'mobileNumber';
const String DOB = 'dob';
const String CITY = 'city';
const String AGE = 'age'; // No corresponding value in enums, kept as is
const String GENDER = 'gender';
const String PASSWORD = 'password'; // No corresponding value in enums, kept as is
const String IS_USER_LOGIN = 'isUserLoggedIn'; // No corresponding value in enums, kept as is
const String USER_NAME = 'username';
const String BACKEND_URL = 'BACKEND_URL'; // No corresponding value in enums, kept as is
const String MESSAGE = 'message'; // No corresponding value in enums, kept as is
const String SUCCESS = 'success'; // No corresponding value in enums, kept as is
const String SIGN_UP = 'signup';
const String FORGOT_PASSWORD = 'forgotPassword';
const String BODY = 'body'; // No corresponding value in enums, kept as is
const String VERIFICATION_TYPE = 'verificationType'; // No corresponding value in enums, kept as is
const String OTP = 'otp'; // No corresponding value in enums, kept as is
const String IS_GUEST_USER = 'isGuestUser'; // No corresponding value in enums, kept as is
const String ADMIN_EMAIL = 'createdByAdminEmail';
const String USER_ID = '_id';
const String IS_FAVOURITE = "isFavourite";
const String MOBILE_NUMBER = "mobileNumber";


void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printResultText(String text) {
  print('\x1B[31m$text\x1B[0m');
}

void printError(dynamic message) {
  print('\x1B[31m[ERROR]: $message\x1B[0m');
}