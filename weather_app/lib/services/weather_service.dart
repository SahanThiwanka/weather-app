import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String baseUrl = 'http://192.168.8.158:3000';

  // Fetch weather by current location
  Future<Map<String, dynamic>?> getWeatherByLocation(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weather/location?lat=$lat&lon=$lon'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error fetching location weather: $error");
      return null;
    }
  }

  // Fetch weather by city name
  Future<Map<String, dynamic>?> getWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weather/$city'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error fetching city weather: $error");
      return null;
    }
  }

  // Fetch 5-day weather forecast by city
  Future<Map<String, dynamic>?> getWeatherForecast(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weather/forecast/$city'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error fetching 5-day forecast: $error");
      return null;
    }
  }
}
