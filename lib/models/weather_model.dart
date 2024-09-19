class Weather {

  final String cityName;
  final double temperatureCelsius;
  final String weatherCondition;

  Weather({
    required this.cityName,
    required this.temperatureCelsius,
    required this.weatherCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperatureCelsius: json['main']['temp'].toDouble(),
      weatherCondition: json['weather'][0]['main'],
    );    
  }
}