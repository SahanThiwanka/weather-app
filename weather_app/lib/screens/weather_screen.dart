import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final cityController = TextEditingController();
  Map<String, dynamic>? currentWeatherData;
  Map<String, dynamic>? forecastData;
  bool isLoading = false;

  // Fetch current weather
  void fetchCurrentWeather(String city) async {
    setState(() => isLoading = true);
    final data = await WeatherService().getWeather(city);
    setState(() {
      currentWeatherData = data;
      isLoading = false;
    });
  }

  // Fetch 5-day weather forecast
  void fetchWeatherForecast(String city) async {
    setState(() => isLoading = true);
    final data = await WeatherService().getWeatherForecast(city);
    setState(() {
      forecastData = data;
      isLoading = false;
    });
  }

  // Combined function to fetch both current weather and forecast
  void fetchWeatherData(String city) {
    if (city.isNotEmpty) {
      fetchCurrentWeather(city);
      fetchWeatherForecast(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField for entering city name
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final city = cityController.text;
                fetchWeatherData(city);
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),

            // Display current weather
            if (isLoading)
              CircularProgressIndicator()
            else if (currentWeatherData != null)
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Weather in ${currentWeatherData!['city']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Temperature: ${currentWeatherData!['temperature']}°C'),
                      Text('Description: ${currentWeatherData!['description']}'),
                      Text('Humidity: ${currentWeatherData!['humidity']}%'),
                      Text('Wind Speed: ${currentWeatherData!['windSpeed']} m/s'),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Display 5-day weather forecast
            if (forecastData != null)
              Expanded(
                child: ListView.builder(
                  itemCount: forecastData!['forecast'].length,
                  itemBuilder: (context, index) {
                    final item = forecastData!['forecast'][index];
                    return Card(
                      child: ListTile(
                        leading: Image.network(
                          'https://openweathermap.org/img/wn/${item['icon']}@2x.png',
                          width: 50,
                        ),
                        title: Text('${item['date']}'),
                        subtitle: Text('${item['description']}'),
                        trailing: Text('${item['temperature']}°C'),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
