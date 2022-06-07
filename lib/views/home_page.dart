import 'package:flutter/material.dart';

import '../models/city.dart';
import '../models/meteo.dart';
import '../utils/variables.dart';

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
  List<Meteo> listHoursWeather = [];
  List<Meteo> list5DaysWeather = [];
var fieldText = TextEditingController();
late var cities = null;
  @override
  void initState() {
    super.initState();
    for (Meteo weather in widget.city5DaysWeather) {
      if (weather.date!.day == DateTime.now().day) {
        listHoursWeather.add(weather);
      }
    }
    for (Meteo weather in widget.city5DaysWeather) {
      if (weather.date!.hour == 12) {
        list5DaysWeather.add(weather);
      }
    }
database.fetchCities().then((value) {
      setState(() {
        cities = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Météo"),
        elevation: 0,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.cityWeather.name!),
            Text(
                "${convertKelvinToCelsus(widget.cityWeather.main.temp).toStringAsFixed(0)}°C"),
            Text(widget.cityWeather.weather[0].main),
            Text(widget.cityWeather.weather[0].description),
            Container(
              height: 300,
              child: ListView.builder(
                  itemCount: listHoursWeather.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(listHoursWeather[index].weather[0].description),
                      subtitle: Text(listHoursWeather[index].date!.toString()),
                      trailing: Text(
                          "${convertKelvinToCelsus(listHoursWeather[index].main.temp).toStringAsFixed(0)}°C\n${convertMeterSecondToKilometerHour(listHoursWeather[index].wind?.speed).toStringAsFixed(1)}km/h"),
                    );
                  }),
            ),
            Container(
              height: 300,
              child: ListView.builder(
                  itemCount: list5DaysWeather.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title:
                          Text(list5DaysWeather[index].weather[0].description),
                      subtitle: Text(list5DaysWeather[index].date!.toString()),
                      trailing: Text(
                          "${convertKelvinToCelsus(list5DaysWeather[index].main.temp).toStringAsFixed(0)}°C\n${convertMeterSecondToKilometerHour(list5DaysWeather[index].wind?.speed).toStringAsFixed(1)}km/h"),
                    );
                  }),
            )
          ]),
      drawer: drawer(),
    );
  }

  Drawer drawer() {
    return Drawer(
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 80, 10, 0),
            child: Column(children: [
              TextField(
                controller: fieldText,
                onSubmitted: (userValue) => addFavoriteCity(userValue),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: fieldText.clear,
                    ),
                    hintText: 'Ajouter une ville',
                    border: InputBorder.none),
              ),
              Container(
                height: 650,
                child: ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: ((context, index) {
                      var city = cities[index];
                      return ListTile(title: Text(city.name));
                    })),
              )
            ])));
  }

  void addFavoriteCity(String name) async {
    await database.insertCity(City(name));
    database.fetchCities().then((value) {
      setState(() {
        cities = value;
      });
    });
    fieldText.clear();
  }

  double convertKelvinToCelsus(double degree) {
    return degree - 273.15;
  }
}

double convertMeterSecondToKilometerHour(double? speed) {
  if (speed != null) return speed * 3.6;
  return 0;
}
