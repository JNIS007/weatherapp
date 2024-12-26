import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {

  static const BASE_URL = "https://api.openweathermap.org/data/2.5/";
  static const API_KEY = "0b3feaf692b9b94d176679b8e2a33f37";
  final String apiKey;

  WeatherService(this.apiKey);
  Future<Weather> getWeather(String cityName, ) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY')
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body)
      );
    }

    else {
      throw Exception('failed to load weather data');
    }
  }
  Future<String> getCurrentCity() async {
    //get permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );


    //convert location into list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);


    //extract city name from first placemark
    String? city =  placemarks[0].locality;
    return city ?? "";
  }
}