import 'package:appli_meteo/models/meteo.dart';
import 'package:appli_meteo/services/meteo_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key? key, required this.cityWeather, required this.city5DaysWeather})
      : super(key: key);
  final Meteo cityWeather;
  final List<Meteo> city5DaysWeather;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Meteo> list5DaysWeather;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.cityWeather.name!),
            Text(
                "${convertKelvinToCelsus(widget.cityWeather.main.temp).toStringAsFixed(0)}°C"),
            Text(widget.cityWeather.weather[0].main),
            Text(widget.cityWeather.weather[0].description),
            Container(
              height: 400,
              child: ListView.builder(
                  itemCount: widget.city5DaysWeather.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(widget
                          .city5DaysWeather[index].weather[0].description),
                      subtitle:
                          Text(widget.city5DaysWeather[index].date!.toString()),
                      trailing: Text(
                          "${convertKelvinToCelsus(widget.city5DaysWeather[index].main.temp).toStringAsFixed(0)}°C"),
                    );
                  }),
            )
          ]),
    );
  }
}

double convertKelvinToCelsus(double degree) {
  return degree - 273.15;
}
