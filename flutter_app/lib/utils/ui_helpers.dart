import 'package:flutter/material.dart';
import 'package:matrimony_app/utils/string_const.dart';
import 'package:dio/dio.dart';

void handleErrors(BuildContext context, dynamic error) {
  if (!context.mounted) return;

  String errorMessage = "An unknown error occurred";
  String errorTitle = "Error";
  IconData errorIcon = Icons.error_outline;
  Color errorColor = Colors.red;
  
  // Handle different error types
  if (error is String) {
    // String error
    errorMessage = error;
    if (error.toLowerCase().contains("warning")) {
      errorTitle = "Warning";
      errorIcon = Icons.warning_amber_rounded;
      errorColor = Colors.orange;
    }
  } else if (error is DioException) {
    // Dio API errors
    errorTitle = "Error";
    errorIcon = Icons.signal_wifi_statusbar_connected_no_internet_4;
    
    if (error.response != null) {
      // Server responded with an error
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      
      if (responseData is Map && responseData.containsKey('message')) {
        errorMessage = responseData['message'];
      } else if (responseData is String) {
        errorMessage = responseData;
      } else {
        errorMessage = "Server error: ${statusCode ?? 'Unknown status'}";
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      errorMessage = "Connection timeout. Please check your internet connection.";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      errorMessage = "Server is taking too long to respond. Please try again later.";
    } else if (error.type == DioExceptionType.connectionError) {
      errorMessage = "No internet connection. Please check your network.";
    } else {
      errorMessage = "Network error: ${error.message}";
    }
  } else if (error is Exception) {
    // General exceptions
    errorMessage = error.toString().replaceFirst("Exception: ", "");
  } else if (error is Error) {
    // Dart errors
    errorTitle = "Application Error";
    errorIcon = Icons.bug_report;
    errorMessage = "Application error: ${error.toString()}";
  }
  
  // Log the error
  printError(error);

  // Show error dialog with improved UI and scrollable content
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(errorIcon, color: errorColor, size: 24),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              errorTitle,
              style: TextStyle(
                color: errorColor,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                errorMessage,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Please try again or contact support if the issue persists.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "OK",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
