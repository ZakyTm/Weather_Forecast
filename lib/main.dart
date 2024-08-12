import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_forecast/ui/home_page.dart';
import 'package:http/http.dart' as http;



void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  static String API_Key = 'abf1117e552c4f9d9d1143140241108';
  String location = 'Boumerdes';
  String weatherIcon = 'heavycloudy.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

// API Call
  String searchWeatherAPI =
      'https://api.weatherapi.com/v1/current.json?key=$API_Key&days=7&q=';


  void fetchWeatherData(String searchText) async {
    try{
        var searchResult = await http.get(Uri.parse(searchWeatherAPI + searchText));


        final weatherData = Map<String, dynamic>.from(json.decode(searchResult.body)?? 'No data');


        var locationData = weatherData ['location'];
        
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather_forecast app',
        home: HomePage());
  }
}
