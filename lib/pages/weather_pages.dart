import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m_w/models/weather_model.dart';
import 'package:m_w/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with TickerProviderStateMixin {
// api key

  final _weatherService = WeatherService('1cf4c4e7789296c79e78253b93114f20');
  Weather? _weather;

//fetch weather
  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //error handling
    catch (e) {
      print(e);
    }
  }

  //weather animations
  String getweatherAnimation(String? weathercondition) {
    if (weathercondition == null) return 'assets/sunny.json';
    switch (weathercondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'fog':
      case 'haze':
      case 'dust':
      case 'smoke':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

// Add this to your state class
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchWeather();

    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //city name
              Text(
                _weather?.cityName ?? "Loading City",
                style:  TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600], // Change the color here
                ),
              ),

              //animation
              Lottie.asset(getweatherAnimation(_weather?.weatherCondition)),

              //temperature
              Text(
                '${_weather?.temperatureCelsius.round()}°C',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600], // Change the color here
                ),
              ),

              //weather condition
              FadeTransition(
                opacity: _animation,
                child: Text(
                  _weather?.weatherCondition ?? "",
                  style: TextStyle(
                    fontSize: 34,
                    color: Colors.grey[400],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
