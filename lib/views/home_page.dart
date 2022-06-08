import 'package:appli_meteo/components/detail_weather.dart';
import 'package:appli_meteo/components/weather_information.dart';
import 'package:appli_meteo/extensions/string.dart';
import 'package:appli_meteo/main.dart';
import 'package:appli_meteo/services/color.dart';
import 'package:appli_meteo/services/day.dart';
import 'package:appli_meteo/services/meteo_service.dart';
import 'package:flutter/material.dart';

import 'package:appli_meteo/models/city.dart';
import 'package:appli_meteo/models/meteo.dart';
import 'package:appli_meteo/utils/variables.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.myAppSettings}) : super(key: key);
  final MyAppSettings myAppSettings;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Meteo cityWeather =
      Meteo(0, "", [], Main(0, 0, 0, 0, 0, 0), null, Wind(0.0), DateTime(2022));
  List<Meteo> city5DaysWeather = [];
  List<Meteo> listHoursWeather = [];
  List<Meteo> list5DaysWeather = [];
  var fieldText = TextEditingController();
  dynamic cities = [];
  bool charged = false;

  @override
  void initState() {
    super.initState();
    initialization().then((data) {
      setState(() {
        charged = data;
      });
    });
  }

  Future initialization() async {
    await database.initDb();
    cityWeather = await getCityWeather(widget.myAppSettings.city.getValue());
    city5DaysWeather =
        await getCity5DaysWeather(widget.myAppSettings.city.getValue());
    int idx = 0;
    while (listHoursWeather.length < 8) {
      if (city5DaysWeather[idx].date.isAfter(cityWeather.date)) {
        listHoursWeather.add(city5DaysWeather[idx]);
      }
      idx++;
    }
    for (Meteo weather in city5DaysWeather) {
      if (weather.date.hour == 12) {
        list5DaysWeather.add(weather);
      }
    }
    database.fetchCities().then((value) {
      setState(() {
        cities = value;
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (charged == false) {
      return Container();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Météo"),
          backgroundColor: getColor(cityWeather.weather[0].icon),
          elevation: 0,
        ),
        body: PreferenceBuilder<String>(
            preference: widget.myAppSettings.city,
            builder: (BuildContext context, String city) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [header(), descriptionMeteo()]);
            }),
        drawer: drawer(),
      );
    }
  }

  ClipRRect header() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(50)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        color: getColor(cityWeather.weather[0].icon),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(cityWeather.name!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "${cityWeather.main.tempMin.toStringAsFixed(0)}°",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 20), // give it width
                Text("${cityWeather.main.temp.toStringAsFixed(0)}°",
                    style: const TextStyle(color: Colors.white, fontSize: 35)),
                const SizedBox(width: 20), // give it width
                Text("${cityWeather.main.tempMax.toStringAsFixed(0)}°",
                    style: const TextStyle(color: Colors.white))
              ]),
              const SizedBox(height: 30), // give it width
              Image.asset(
                  "assets/weather_icon/${cityWeather.weather[0].icon.substring(0, 2)}.png",
                  height: MediaQuery.of(context).size.height * 0.25),
              const SizedBox(width: 30), // give it width
              Text(cityWeather.weather[0].description.capitalize(),
                  style: const TextStyle(color: Colors.white, fontSize: 20))
            ]),
      ),
    );
  }

  Container descriptionMeteo() {
    return Container(
        color: getColor(cityWeather.weather[0].icon),
        height: MediaQuery.of(context).size.height * 0.38,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50)),
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
                                      degrees: meteo.main.temp,
                                      hours: "${meteo.date.hour.toString()}h",
                                      pathImage:
                                          "assets/weather_icon/${listHoursWeather[index].weather[0].icon.substring(0, 2)}.png");
                                }),
                                itemCount: listHoursWeather.length),
                          )
                        : const Text(""),
                    const SizedBox(height: 10),
                    rowInformations(),
                    const SizedBox(height: 7),
                    weather5Days(),
                  ])),
        ));
  }

  Row rowInformations() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              DetailWeather(
                  information: "Levé du soleil",
                  value: convertToDate(cityWeather.sys!.sunrise)),
              DetailWeather(
                  information: "Vent",
                  value:
                      "${(cityWeather.wind!.speed * 3.6).toStringAsFixed(1)} km/h"),
              DetailWeather(
                  information: "Pression",
                  value: "${cityWeather.main.pressure} hPa"),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              DetailWeather(
                  information: "Couché du soleil",
                  value: convertToDate(cityWeather.sys!.sunset)),
              DetailWeather(
                  information: "Humidité",
                  value: "${cityWeather.main.humidity}%"),
              DetailWeather(
                  information: "°C Ambiante",
                  value: "${cityWeather.main.feelsLike.toStringAsFixed(0)} °C"),
            ],
          ),
        )
      ],
    );
  }

  String convertToDate(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value * 1000);
    return "${date.hour}:${date.minute}";
  }

  Widget weather5Days() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list5DaysWeather
            .map((weatherInfo) => WeatherInformations(
                  degrees: weatherInfo.main.temp,
                  hours: getDay(weatherInfo.date.weekday),
                  pathImage:
                      "assets/weather_icon/${weatherInfo.weather[0].icon.substring(0, 2)}.png",
                ))
            .toList());
  }

  Drawer drawer() {
    return Drawer(
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 80, 10, 0),
            child: Column(children: [
              TextField(
                controller: fieldText,
                onSubmitted: (userValue) {
                  if (userValue != "" && userValue != " ") {
                    addFavoriteCity(userValue);
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: fieldText.clear,
                    ),
                    hintText: 'Ajouter une ville',
                    border: InputBorder.none),
              ),
              cities != []
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: ((context, index) {
                            var city = cities[index];
                            return Dismissible(
                              key: ValueKey<City>(cities[index]),
                              background: Container(
                                color: Colors.red,
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    deleteCity(city);
                                    cities.removeAt(index);
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    deleteCity(city);
                                    cities.removeAt(index);
                                  }
                                });
                              },
                              child: ListTile(
                                title: Text(city.name),
                                onTap: () async {
                                  setState(() {
                                    widget.myAppSettings.city
                                        .setValue(city.name);
                                    Navigator.pop(context, true);
                                  });
                                },
                              ),
                            );
                          })),
                    )
                  : const Text("LOADER")
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

  void deleteCity(City city) {
    database.delete(city);
  }
}
