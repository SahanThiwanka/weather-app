import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReminderService {
  final String baseUrl = "http://192.168.8.158:3000/reminders";

  Future<List<Map<String, dynamic>>?> getReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching reminders: $error");
      return null;
    }
  }

  Future<bool> createReminder(String title, String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"title": title, "date": date}),
      );

      return response.statusCode == 201;
    } catch (error) {
      print("Error creating reminder: $error");
      return false;
    }
  }

  Future<bool> deleteReminder(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {"Authorization": "Bearer $token"},
      );

      return response.statusCode == 200;
    } catch (error) {
      print("Error deleting reminder: $error");
      return false;
    }
  }

  Future<bool> updateReminder(String id, String title, String date) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.put(
      Uri.parse('http://192.168.8.158:3000/reminders/$id'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "title": title,
        "date": date,
      }),
    );

    return response.statusCode == 200;
  } catch (error) {
    print("Error updating reminder: $error");
    return false;
  }
}

}
