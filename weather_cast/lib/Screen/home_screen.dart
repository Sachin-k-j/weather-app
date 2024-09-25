import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_cast/Model/weather_model.dart';
import 'package:weather_cast/Services/weather_service.dart';

class Weatherhomme extends StatefulWidget {
  const Weatherhomme({super.key});

  @override
  State<Weatherhomme> createState() => _WeatherhommeState();
}

class _WeatherhommeState extends State<Weatherhomme> {
  late WeatherData weatherInfo;
  bool isLoading = false;
  myWeather() {
    isLoading = true;
    WeatherService().fetchWeather().then((value) {
      setState(() {
        weatherInfo = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    weatherInfo = WeatherData(
        name: '',
        temperature: Temperature(current: 0.0),
        humidity: 0,
        wind: Wind(speed: 0.0),
        maxTemperature: 0,
        minTemperature: 0,
        pressure: 0,
        seaLevel: 0,
        weather: []);
    myWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formatteDate = DateFormat('EEEE d,MMMM yyyy').format(DateTime.now());
    String formatteTime = DateFormat('hh:mm a').format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isLoading
                  ? WeatherDetail(
                      weather: weatherInfo,
                      formattedDate: formatteDate,
                      formattedTime: formatteTime)
                  : const CircularProgressIndicator(
                      color: Colors.red,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;

  const WeatherDetail(
      {super.key,
      required this.weather,
      required this.formattedDate,
      required this.formattedTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.name,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          "${weather.temperature.current.toStringAsFixed(2)}°C",
          style: const TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (weather.weather.isNotEmpty)
          Text(
            weather.weather[0].main,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 30),
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cloudy.png"),
            ),
          ),
        ),
        const SizedBox(height: 30),
        // for more weather detail
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.wind_power,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        weatherInfoCard(
                            title: "wind", value: "${weather.wind.speed}km/h")
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sunny,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Max",
                            value:
                                "${weather.maxTemperature.toStringAsFixed(2)}°C"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wind_power,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Min",
                            value:
                                "${weather.minTemperature.toStringAsFixed(2)}°C"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wind_power,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Min",
                            value:
                                "${weather.minTemperature.toStringAsFixed(2)}°C"),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.amber,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        weatherInfoCard(
                            title: "Humidity", value: "${weather.humidity}%")
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.air,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Pressure", value: "${weather.pressure}hPa"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.leaderboard,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 5),
                        weatherInfoCard(
                            title: "Sea-Level", value: "${weather.seaLevel}m"),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column weatherInfoCard({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
