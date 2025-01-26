import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://192.168.8.158:3000/auth"; // Replace with your backend URL if different.

  Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; // Return the JWT token.
      } else {
        return null; // Login failed.
      }
    } catch (error) {
      print("Error during login: $error");
      return null;
    }
  }

  Future<bool> signup(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      return response.statusCode == 201; // Returns true if signup is successful.
    } catch (error) {
      print("Error during signup: $error");
      return false;
    }
  }
}
