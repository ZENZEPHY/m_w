import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:m_w/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    //! get permission for user

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //! fetch current location

    Position position = await Geolocator.getCurrentPosition(

        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    //! convernt into place mark

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //! fetch city name from current location

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
