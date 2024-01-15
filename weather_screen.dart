import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/weather_forecast.dart';
import 'package:weather_app/additinal_info.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secerate.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future getCurrentWeather() async {
    try {
      double latitude = 19.0785451;
      double longitude = 72.878176;
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$openWeatherApiKey' /*'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=$callLimit&appid=$openWeatherApiKey'*/),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message'];
        //'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        toolbarTextStyle: const TextStyle(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final pressure = currentWeatherData['main']['pressure'];
          final humidity = currentWeatherData['main']['humidity'];
          final speed = currentWeatherData['wind']['speed'];

          return Column(
            children: [
              //main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "$currentTemp K",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            currentSky == 'Clouds' || currentSky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 48,
                          ),
                          Text(
                            currentSky,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //weatherforecast card

              const Text(
                "Weather Forecast",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              /* SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            ForecastCard(
                              lable: data['list'][i + 1]['dt'].toString(),
                              icon: data['list'][i + 1]['weather'][0]['main'] ==
                                          'Clouds' ||
                                      data['list'][i + 1]['weather'][0]
                                              ['main'] ==
                                          'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              value: data['list'][i + 1]['main']['temp']
                                  .toString(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),*/
              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    final lable_Time = data['list'][index + 1]['dt_txt'];
                    final label_Icon =
                        data['list'][index + 1]['weather'][0]['main'];
                    final label_Value = data['list'][index + 1]['main']['temp'];
                    final time = DateTime.parse(lable_Time);
                    return ForecastCard(
                        lable: DateFormat.j().format(time),
                        icon: label_Icon == 'Clouds' || label_Icon == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        value: label_Value.toString());
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //additional information
              const Text(
                "Additinal information",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AdditinalInfo(
                    icon: Icons.water_drop,
                    lable: "Humidity",
                    value: humidity.toString(),
                  ),
                  AdditinalInfo(
                      icon: Icons.wind_power,
                      lable: "Wind speed",
                      value: speed.toString()),
                  AdditinalInfo(
                    icon: Icons.storm,
                    lable: "Pressure",
                    value: pressure.toString(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
