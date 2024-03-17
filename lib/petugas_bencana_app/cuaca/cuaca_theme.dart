import 'package:intl/intl.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/cuaca/weather_service.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/cuaca/weather_model.dart';
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
                    ? '${_weather?.cityName ?? ""}, ${_weather?.county ?? ""}, ${_weather?.district ?? ""}'
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
          color: Colors.grey.withOpacity(0.5),
        ),
        child: ExpansionTile(
          title: Text(
            DateFormat('EEEE, MMMM d').format(day),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: forecasts.map((forecast) {
            return WeatherForecastCard(
              forecast: forecast,
              backgroundColor: Colors.grey.withOpacity(0.5),
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
  final VoidCallback? onTap;
  final bool isExpanded;
  final Color backgroundColor;

  WeatherForecastCard({
    required this.forecast,
    this.onTap,
    this.isExpanded = false,
    required this.backgroundColor,
  });

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            child: Lottie.asset(
              getWeatherAnimation(mainCondition: forecast.mainCondition),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${forecast.dateTime.hour}:00, ${forecast.temperature.round()}°C, ${forecast.mainCondition}, ${forecast.windSpeed} m/s Wind',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
