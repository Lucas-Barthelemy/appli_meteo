import 'package:appli_meteo/models/meteo.dart';
import 'package:appli_meteo/services/meteo_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.cityWeather}) : super(key: key);
  final Meteo cityWeather;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.cityWeather.name),
            Text(
                "${convertKelvinToCelsus(widget.cityWeather.main.temp).toStringAsFixed(0)}°C"),
            Text(widget.cityWeather.weather[0].main),
            Text(widget.cityWeather.weather[0].description),
          ]),
    );
  }
}

double convertKelvinToCelsus(double degree) {
  return degree - 273.15;
}
