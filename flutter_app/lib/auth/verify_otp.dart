import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimony_app/dashboard/dashboard_screen_bottom_navigation_bar.dart';
import 'package:matrimony_app/utils/animated_tick.dart';
import 'package:matrimony_app/utils/helpers.dart';
import 'package:matrimony_app/utils/services.dart';
import 'package:matrimony_app/utils/string_const.dart';
import 'package:matrimony_app/utils/ui_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony_app/utils/handle_req_res.dart';

class VerifyOtpPage extends StatefulWidget {
  final String verificationType;
  final String email;
  final String username;

  const VerifyOtpPage({
    super.key,
    required this.verificationType,
    required this.email,
    required this.username,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  String? _errorMessage;
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _getTitle {
    return widget.verificationType == SIGN_UP
        ? 'Verify Your Email'
        : 'Verify Your Identity';
  }

  String get _getSubtitle {
    return widget.verificationType == SIGN_UP
        ? 'We\'ve sent a code to ${widget.email}'
        : 'Enter the code sent to ${widget.email} to reset your password';
  }

  String get _getButtonText {
    return widget.verificationType == SIGN_UP
        ? 'Create Account'
        : 'Verify & Continue';
  }

  Future<void> _verifyOtp() async {

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });
    // Combine OTP digits
    final otp = _otpControllers.map((controller) => controller.text).join();

    // Validate OTP length
    if (otp.length != 4) {
      setState(() {
        _errorMessage = 'Please enter all 4 digits';
        _isVerifying = false;
      });
      return;
    }

    try {
      dynamic responseBody = await postRequest(url: '/api/verify-otp', body: {
        EMAIL: widget.email,
        OTP: otp,
        VERIFICATION_TYPE: widget.verificationType
      });

      if (!responseBody[SUCCESS]) {
        throw Exception(responseBody[MESSAGE]);
      }

      showGreenSnackBar(context, responseBody[MESSAGE]);

      await Services.setSharedPreferences(
          email: widget.email, userName: widget.username);

      pushAndRemoveUntilForFirstPage(context);
    } catch (error) {
      printError(error);
      handleErrors(context, error.toString());
    } finally {
      setState(() {
        _isVerifying = false;
        _errorMessage = null;
      });
    }
  }

  Future<void> _resendCode() async {
    print(VERIFICATION_TYPE);
    Services.showProgressDialog(context);
    try {
      dynamic responseBody = await postRequest(url: "/api/resend-otp", body: {
        EMAIL: widget.email,
        VERIFICATION_TYPE: widget.verificationType,
      });

      showGreenSnackBar(context, 'A new verification code has been sent');
    } catch (error) {
      handleErrors(context, error.toString());
    } finally {
      Services.dismissProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Icon(
                          Icons.mark_email_read,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _getSubtitle,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 40),

                        // OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => SizedBox(
                              width: 60,
                              height: 60,
                              child: TextFormField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 3) {
                                    _focusNodes[index + 1].requestFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        // Error Message
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Resend Code
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: _resendCode,
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyOtp,
                    child: _isVerifying
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_getButtonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
