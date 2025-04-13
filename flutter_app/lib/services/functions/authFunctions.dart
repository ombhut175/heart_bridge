import 'package:matrimony_app/utils/exports/auth.dart';



Future<void> handleResetPassword({
  required GlobalKey<FormState> formKey,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required context
}) async {



  if (!formKey.currentState!.validate()) {
    printError("error in forget password");
    return;
  }

  String email = emailController.text.toString();
  String password = passwordController.text.toString();

  try {
    dynamic responseBody = await patchRequest(
        url: RouteConstants.FORGET_PASSWORD, body: {EMAIL: email, PASSWORD: password});


    if (!responseBody[SUCCESS]) {
      throw Exception(responseBody[MESSAGE]);
    }

    showGreenSnackBar(context, responseBody[MESSAGE]);

    print("after showGreenSnackBar");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VerifyOtpPage(
              verificationType: FORGOT_PASSWORD,
              email: email,
              username: responseBody[BODY][USER_NAME],
            ))
    );
  } catch (error) {
    handleErrors(context, error.toString());
  }
}


Future<void> handleLogin({
  required GlobalKey<FormState> formKey,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required context
}) async {
  if (!formKey.currentState!.validate()) {
    print("Please complete the validation");
    return;
  }

  String email = emailController.text.toString();
  String password = passwordController.text.toString();

  try {
    dynamic responseBody = await postRequest(
        url: RouteConstants.SIGN_IN, body: {EMAIL: email, PASSWORD: password});

    if (!responseBody[SUCCESS]) {
      throw Exception(responseBody[MESSAGE]);
    }

    print("::: login submit :::");

    print(responseBody);

    await Services.setSharedPreferences(
      email: email, userName: responseBody[BODY][USER_NAME],
    );

    await SecureStorageServices.saveToken(responseBody[BODY][USER_TOKEN]);

    pushAndRemoveUntilForFirstPage(context);
  } catch (error) {
    handleErrors(context, error.toString());
  }
}

Future<void> handleSignUp({
  required GlobalKey<FormState> formKey,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController usernameController,
  required context
}) async {

  if (!formKey.currentState!.validate()) {
    print("Please confirm the validation");
    return;
  }


  String userName = usernameController.text.trim().toString();
  String email = emailController.text.trim().toString();
  String password = passwordController.text.trim().toString();

  try {
    Map<String, dynamic> userMap = {
      USER_NAME: userName,
      EMAIL: email,
      PASSWORD: password
    };

    dynamic responseBody =
    await postRequest(url: RouteConstants.SIGN_UP, body: userMap);


    if (!responseBody[SUCCESS]) {
      throw Exception(responseBody[MESSAGE]);
    }

    showGreenSnackBar(context, responseBody[MESSAGE]);

    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return VerifyOtpPage(
          verificationType: SIGN_UP,
          email: email,
          username: userName,
        );
      },
    ));
  } catch (error) {
    printError(error);
    handleErrors(context, error.toString());
    return;
  }
}


Future<void> resendCode({
  required String email,
  required String verificationType,
  required context
}) async {
  try {
    dynamic responseBody = await postRequest(url: RouteConstants.RESEND_OTP, body: {
      EMAIL: email,
      VERIFICATION_TYPE: verificationType,
    });

    showGreenSnackBar(context, 'A new verification code has been sent');
  } catch (error) {
    handleErrors(context, error.toString());
  }
}


Future<void> verifyOtp({
  required BuildContext context,
  required List<TextEditingController> otpControllers,
  required String email,
  required String username,
  required String verificationType,
  required Function(bool isVerifying, String? errorMessage) updateState,
}) async {
  updateState(true, null);

  final otp = otpControllers.map((controller) => controller.text).join();

  if (otp.length != 4) {
    updateState(false, 'Please enter all 4 digits');
    return;
  }

  try {
    dynamic responseBody = await postRequest(url: RouteConstants.VERIFY_OTP, body: {
      EMAIL: email,
      OTP: otp,
      VERIFICATION_TYPE: verificationType,
    });

    if (!responseBody[SUCCESS]) {
      throw Exception(responseBody[MESSAGE]);
    }

    showGreenSnackBar(context, responseBody[MESSAGE]);

    await Services.setSharedPreferences(email: email, userName: username);
    await SecureStorageServices.saveToken(responseBody[BODY][USER_TOKEN]);
    pushAndRemoveUntilForFirstPage(context);
  } catch (error) {
    printError(error);
    handleErrors(context, error.toString());
  } finally {
    updateState(false, null);
  }
}
