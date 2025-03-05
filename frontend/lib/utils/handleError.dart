import 'dart:convert';
import 'package:http/http.dart' as http;

dynamic handleApiResponse(http.Response response) {
    try {
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (response.statusCode >= 200 && response.statusCode < 300) {
            return responseBody; // Return decoded JSON data
        } else {
            String errorMessage = responseBody["message"] ?? "Unexpected error occurred";
            throw Exception("Error ${response.statusCode}: $errorMessage");
        }
    } catch (e) {
        throw Exception("Failed to parse response: ${response.body}");
    }
}
