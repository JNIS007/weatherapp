import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('0b3feaf692b9b94d176679b8e2a33f37');
  Weather ? _weather;
  // fetch weather
  _fetchWeather () async{
    // get current city
    String cityName =  await _weatherService.getCurrentCity();
    // get weather for city

    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // catch errors
    catch (e) {
      print(e);
    }
  }
  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if ( mainCondition == null) return 'assets/sunny.json'; //default

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'fog':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/thunderrain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }


  // initial state

  @override
  void initState(){
    super.initState();

    // fetch weather on startup
    _fetchWeather();

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name
            Text(_weather?.cityName ?? "loading city.."),
            
            //animation
            Lottie.asset('assets/sunny.json'),
            
            //temperature
            Text('${_weather?.temperature.round()}°C'),

            //weather condition
            Text(_weather?.mainCondition ?? ""),
          ],
        ),
      ),

    );
  }
}
