import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/cuaca/weather_service.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/cuaca/weather_model.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherTheme(),
    );
  }
}

class WeatherTheme extends StatefulWidget {
  const WeatherTheme({Key? key}) : super(key: key);

  @override
  State<WeatherTheme> createState() => _WeatherThemeState();
}

class _WeatherThemeState extends State<WeatherTheme> {
  final _weatherService = WeatherService('c4829a7aa3b361a5740d769b7fda4438');
  WeatherModel? _weather;
  List<WeatherModel>? _forecast;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetchForecast();
  }

  _fetchWeather() async {
    try {
      final cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeatherForUserLocation(
        cityName: cityName,
      );
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  _fetchForecast() async {
    try {
      final forecast = await _weatherService.getForecastForUserLocation();
      setState(() {
        _forecast = forecast;
      });
    } catch (e) {
      print('Error fetching forecast: $e');
    }
  }

  String getWeatherAnimation({String? mainCondition}) {
    if (mainCondition == null) return 'assets/animation/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/animation/cloud.json';
      case 'rain':
        return 'assets/animation/rain.json';
      case 'drizzle':
      case 'shower rain':
        return 'assets/animation/rain.json';
      case 'thunderstorm':
        return 'assets/animation/thunder.json';
      case 'clear':
        return 'assets/animation/sunny.json';
      default:
        return 'assets/animation/sunny.json';
    }
  }

  IconData getWeatherIcon({String? mainCondition}) {
    if (mainCondition == null) return Icons.wb_sunny;

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return Icons.cloud;
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return Icons.filter_drama;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return Icons.beach_access;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'clear':
        return Icons.wb_sunny;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _weather != null
                    ? '${_weather?.cityName ?? ""}'
                    : 'Loading location...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Lottie.asset(
                getWeatherAnimation(mainCondition: _weather?.mainCondition),
                repeat: true,
                reverse: false,
              ),
              SizedBox(height: 20),
              Text(
                _weather != null
                    ? '${_weather?.temperature.round()}°C'
                    : 'Loading temperature...',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                _weather != null
                    ? 'Wind Speed: ${_weather?.windSpeed ?? 0} m/s'
                    : 'Loading wind speed...',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: _buildWeatherForecastSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherForecastSection() {
    if (_forecast == null) {
      return Center(
        child: CircularProgressIndicator(), // Menampilkan indikator loading jika data belum tersedia
      );
    } else {
      // Mengelompokkan perkiraan cuaca berdasarkan hari
      final groupedForecasts = groupForecastsByDay(_forecast!);

      // Membuat ListView.builder untuk menampilkan setiap hari
      return ListView.builder(
        itemCount: groupedForecasts.length,
        itemBuilder: (context, index) {
          DateTime day = groupedForecasts.keys.elementAt(index);
          List<WeatherModel> forecasts = groupedForecasts[day]!;
          return _buildWeatherForecastTile(day, forecasts);
        },
      );
    }
  }

  Widget _buildWeatherForecastTile(DateTime day, List<WeatherModel> forecasts) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 8,
          intensity: 0.8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
        ),
        child: ExpansionTile(
          title: Text(
            DateFormat('EEEE, MMMM d').format(day),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          tilePadding: EdgeInsets.symmetric(horizontal: 16.0), // Mengatur padding tile
          collapsedIconColor: Colors.black,
          iconColor: Colors.black,
          children: forecasts.map((forecast) {
            return WeatherForecastCard(
              forecast: forecast,
              animationAsset: getWeatherAnimation(mainCondition: forecast.mainCondition),
            );
          }).toList(),

        ),
      ),
    );
  }

  Map<DateTime, List<WeatherModel>> groupForecastsByDay(
      List<WeatherModel> forecasts) {
    // Mengelompokkan perkiraan cuaca berdasarkan hari menggunakan Map
    Map<DateTime, List<WeatherModel>> groupedForecasts = {};
    forecasts.forEach((forecast) {
      DateTime day = DateTime(forecast.dateTime.year, forecast.dateTime.month,
          forecast.dateTime.day);
      if (!groupedForecasts.containsKey(day)) {
        groupedForecasts[day] = [];
      }
      groupedForecasts[day]!.add(forecast);
    });
    return groupedForecasts;
  }
}

class WeatherForecastCard extends StatelessWidget {
  final WeatherModel forecast;
  final String animationAsset;

  WeatherForecastCard({
    required this.forecast,
    required this.animationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: null,
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.blue.withOpacity(0.5), Colors.blueAccent.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${forecast.dateTime.hour}:00',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${forecast.temperature.round()}°C',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${forecast.mainCondition}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Wind Speed: ${forecast.windSpeed} m/s',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                height: 60, // Atur tinggi gambar cuaca di sini
                width: 60, // Atur lebar gambar cuaca di sini
                child: Lottie.asset(
                  animationAsset,
                  repeat: true,
                  reverse: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
