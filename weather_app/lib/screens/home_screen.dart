import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  Color backgroundColor = Colors.blue.shade400;

  @override
  void initState() {
    super.initState();
    fetchLocationWeather(); // Automatically fetch location weather
  }

  void fetchLocationWeather() async {
    setState(() => isLoading = true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = await WeatherService().getWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        weatherData = data;
        backgroundColor = getBackgroundColor(weatherData?["description"] ?? "default");
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching location weather: $error");
      setState(() => isLoading = false);
    }
  }

  // Determine background color based on weather condition
  Color getBackgroundColor(String description) {
    if (description.contains("clear")) {
      return Colors.blue.shade400;
    } else if (description.contains("cloud")) {
      return Colors.grey.shade600;
    } else if (description.contains("rain")) {
      return Colors.blueGrey.shade700;
    } else if (description.contains("snow")) {
      return Colors.blue.shade200;
    } else {
      return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Home',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
       automaticallyImplyLeading: false,),
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : weatherData != null
                      ? Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Current Location Weather',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      AnimatedOpacity(
                                                opacity: weatherData != null ? 1.0 : 0.0,
                                                duration: Duration(seconds: 1),
                                                child: Image.network(
                                                  'https://openweathermap.org/img/wn/${weatherData?["icon"]}@2x.png',
                                                  width: 50,
                                                  height: 50,
                                                ),
                                              ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Temperature: ${weatherData!["temperature"]}°C'),
                                        Text('Feels Like: ${weatherData!["feelsLike"]}°C'),
                                        Text('Description: ${weatherData!["description"]}'),
                                      ],
                                    ),
                                  ],
                                ),
                                Text('Humidity: ${weatherData!["humidity"]}%'),
                                Text('Wind Speed: ${weatherData!["windSpeed"]} m/s'),
                                Text('Sunrise: ${weatherData!["sunrise"]}'),
                                Text('Sunset: ${weatherData!["sunset"]}'),
                              ],
                            ),
                          ),
                        )
                      : Center(child: Text("Unable to fetch weather data.")),
              SizedBox(height: 20),
              Container(
                width: 500,
                child: 
                ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/weather');
                },
                child: Text('Search Weather by City'),
              ),
              ),
              Container(
                width: 500,
                child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/reminders');
                },
                child: Text('View Reminders'),
              ),
              )
              ,
            ],
          ),
        ),
      ),
    );
  }
}
