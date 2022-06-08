import 'package:appli_meteo/components/detailWeather.dart';
import 'package:appli_meteo/components/weatherInformation.dart';
import 'package:flutter/material.dart';

import 'package:appli_meteo/models/city.dart';
import 'package:appli_meteo/models/meteo.dart';
import 'package:appli_meteo/utils/variables.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [header(), descriptionMeteo()]),
      drawer: drawer(),
    );
  }

  ClipRRect header() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(50)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20), // give it width
              const Text("LYON",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "low 10°",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 20), // give it width
                  Text("21°",
                      style: TextStyle(color: Colors.white, fontSize: 35)),
                  SizedBox(width: 20), // give it width
                  Text("high 30°", style: TextStyle(color: Colors.white))
                ],
              ),
              SizedBox(height: 30), // give it width
              Image.asset("soleil.png",
                  height: MediaQuery.of(context).size.height * 0.25),
            ]),
      ),
    );
  }

  Container descriptionMeteo() {
    return Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height * 0.38,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
          child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    listHoursWeather.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  var meteo = listHoursWeather[index];
                                  return WeatherInformations(
                                      meteo.main.temp,
                                      meteo.date!.hour.toString(),
                                      "soleil.png");
                                }),
                                itemCount: listHoursWeather.length),
                          )
                        : Text(""),
                    SizedBox(height: 10),
                    rowInformations(),
                    SizedBox(height: 7),
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            var meteo = list5DaysWeather[index];
                            var value = meteo.date!.weekday;
                            var day = "";
                            switch (value) {
                              case 1:
                                day = "Lun";
                                break;
                              case 2:
                                day = "Mar";
                                break;
                              case 3:
                                day = "Mer";
                                break;
                              case 4:
                                day = "Jeu";
                                break;
                              case 5:
                                day = "Ven";
                                break;
                              case 6:
                                day = "Sam";
                                break;
                              case 7:
                                day = "Dim";
                                break;
                              default:
                                day = "";
                            }
                            return WeatherInformations(
                                meteo.main.temp, day, "soleil.png");
                          }),
                          itemCount: list5DaysWeather.length),
                    ), // give it width
                  ])),
        ));
  }

  Row rowInformations() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              DetailWeather(
                  information: "Levé du soleil",
                  value: convertToDate(widget.cityWeather.sys!.sunrise)),
              DetailWeather(
                  information: "Vent",
                  value:
                      "${(widget.cityWeather.wind!.speed * 3.6).toStringAsFixed(1)} km/h"),
              DetailWeather(
                  information: "Pression",
                  value: "${widget.cityWeather.main!.pressure} hPa"),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              DetailWeather(
                  information: "Couché du soleil",
                  value: convertToDate(widget.cityWeather.sys!.sunset)),
              DetailWeather(
                  information: "Humidité",
                  value: widget.cityWeather.main.humidity.toString() + "%"),
              DetailWeather(
                  information: "°C Ambiante",
                  value: widget.cityWeather.main.feelsLike.toStringAsFixed(0) +
                      " °C"),
            ],
          ),
        )
      ],
    );
  }

  String convertToDate(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value * 1000);
    return date.hour.toString() + ":" + date.minute.toString();
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
              cities != null
                  ? Container(
                      height: 650,
                      child: ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: ((context, index) {
                            var city = cities[index];
                            return ListTile(title: Text(city.name));
                          })),
                    )
                  : Text("LOADER")
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
}
