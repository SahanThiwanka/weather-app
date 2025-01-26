import 'package:flutter/material.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/screens/landing_page.dart';
import 'package:weather_app/screens/login_screen.dart';
import 'package:weather_app/screens/onboarding_page.dart';
import 'package:weather_app/screens/reminders_screen.dart';
import 'package:weather_app/screens/signup_screen.dart';
import 'package:weather_app/screens/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/landing': (context) => LandingPage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => Singup_Screen(),
        '/home': (context) => HomeScreen(),
        '/weather': (context) => WeatherScreen(),
        '/reminders': (context) => RemindersScreen(),
      },
    );
  }
}
