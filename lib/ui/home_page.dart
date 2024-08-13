import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:weather_forecast/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This widget is the root of your application.
  final Constants _constants = Constants();
  static String API_Key = 'abf1117e552c4f9d9d1143140241108';
  String location = 'Boumerdes';
  String weatherIcon = 'heavycloudy.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

// API Call
  String searchWeatherAPI =
      'https://api.weatherapi.com/v1/forecast.json?key=$API_Key&days=7&q=';

  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData['location'];

      var currentWeather = weatherData['current'];

      setState(() {
        location = getShortLocationName(locationData["name"]);

        var parseDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('EEEE, d MMM, yyyy').format(parseDate);
        currentDate = newDate;

        //updateWeather
        currentWeatherStatus = currentWeather['condition']['text'];
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', ' ').toLowerCase() + ".png";

        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        //Forecast DAta
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
      });
    } catch (e) {
      //print(e);
    }
  }

  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return ' ';
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
          color: _constants.primaryColor.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: size.height * .7,
                  decoration: BoxDecoration(
                    gradient: _constants.linearGradientBlue,
                    boxShadow: [
                      BoxShadow(
                        color: _constants.primaryColor.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  )),
            ],
          )),
    );
  }
}
