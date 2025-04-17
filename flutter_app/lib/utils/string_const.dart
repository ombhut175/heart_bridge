const String NAME = 'fullName';
const String EMAIL = 'email';
const String PHONE = 'mobileNumber';
const String DOB = 'dob';
const String CITY = 'city';
const String AGE = 'age';
const String GENDER = 'gender';
const String PASSWORD = 'password';
const String IS_USER_LOGIN = 'isUserLoggedIn';
const String USER_NAME = 'username';
const String MESSAGE = 'message';
const String SUCCESS = 'success';
const String SIGN_UP = 'signup';
const String FORGOT_PASSWORD = 'forgotPassword';
const String BODY = 'body';
const String VERIFICATION_TYPE = 'verificationType';
const String OTP = 'otp';
const String IS_GUEST_USER = 'isGuestUser';
const String ADMIN_EMAIL = 'createdByAdminEmail';
const String USER_ID = '_id';
const String IS_FAVOURITE = "isFavourite";
const String MOBILE_NUMBER = "mobileNumber";
const String IS_EDIT_PAGE = "isEditPage";
const String HOBBIES = "hobbies";
const String AUTHORIZATION = "Authorization";
const String BEARER = "Bearer";
const String USER_TOKEN = "userToken";


void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printResultText(String text) {
  print('\x1B[31m$text\x1B[0m');
}

void printError(dynamic message) {
  print('\x1B[31m[ERROR]: $message\x1B[0m');
}

class EnvConst{
  static const String BACKEND_URL = 'BACKEND_URL';
  static const String BACKEND_SECRET_HEADER = "BACKEND_SECRET_HEADER";
}

class RouteConstants{
  static const FORGET_PASSWORD = "/api/reset-password";
  static const VERIFY_OTP = "/api/verify-otp";
  static const RESEND_OTP = "/api/resend-otp";
  static const SIGN_UP = "/api/sign-up";
  static const SIGN_IN = "/api/sign-in";
}