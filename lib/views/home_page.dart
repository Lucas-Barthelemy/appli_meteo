import 'package:appli_meteo/components/detail_weather.dart';
import 'package:appli_meteo/components/weather_information.dart';
import 'package:appli_meteo/extensions/string.dart';
import 'package:appli_meteo/main.dart';
import 'package:appli_meteo/services/meteo_service.dart';
import 'package:appli_meteo/utils/color.dart';
import 'package:appli_meteo/utils/day.dart';
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
  Meteo cityWeather = Meteo(0, "", [], Main(0, 0, 0, 0, 0, 0), Wind(0.0),
      DateTime(2022), DateTime(2022), DateTime(2022));
  List<Meteo> city5DaysWeather = [];
  List<Meteo> listHoursWeather = [];
  List<Meteo> list5DaysWeather = [];
  var fieldText = TextEditingController();
  dynamic cities = [];
  bool charged = false;
  bool changed = false;

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
    late Meteo temp;
    for (Meteo weather in city5DaysWeather) {
      if ((weather.date.hour == 12 ||
              weather.date.hour == 13 ||
              weather.date.hour == 14) &&
          weather.date.day != cityWeather.date.day) {
        list5DaysWeather.add(weather);
      }
      temp = weather;
    }

    if (list5DaysWeather.length < 5) {
      list5DaysWeather.add(temp);
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
      return const Center(child: Text("CECI EST UN LOADER INCROYABLE"));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text((isNight(cityWeather) ? "Nuit" : "Jour")),
          backgroundColor: getColor(cityWeather.weather[0].icon),
          elevation: 0,
        ),
        body: PreferenceBuilder<String>(
            preference: widget.myAppSettings.city,
            builder: (context, city) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [header(), descriptionMeteo()]);
            }),
        drawer: drawer(),
        onDrawerChanged: (value) {
          if (!value) {
            setState(() {
              if (changed) {
                charged = false;
                changed = false;
                list5DaysWeather = [];
                listHoursWeather = [];
                initialization().then((data) {
                  charged = true;
                });
              }
            });
          }
        },
      );
    }
  }

  ClipRRect header() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(50)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        color: getColor(cityWeather.weather[0].icon),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(cityWeather.name!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                        textBaseline: TextBaseline.alphabetic,
                        overflow: TextOverflow.clip)),
              ),
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
              ]), // give it width
              Image.asset(
                  "assets/weather_icons/${cityWeather.weather[0].icon}.png",
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.height * 0.20),
              Text(cityWeather.weather[0].description.capitalize(),
                  style: const TextStyle(color: Colors.white, fontSize: 20))
            ]),
      ),
    );
  }

  Container descriptionMeteo() {
    return Container(
        color: getColor(cityWeather.weather[0].icon),
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(50)),
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: weatherHours(),
                    ),
                    rowInformations(),
                    weather5Days(),
                  ],
                ),
              ),
            )));
  }

  // Container descriptionMeteo() {
  //   return Container(
  //       color: getColor(cityWeather.weather[0].icon),
  //       height: MediaQuery.of(context).size.height * 0.40,
  //       width: MediaQuery.of(context).size.width,
  //       child: ClipRRect(
  //         borderRadius: const BorderRadius.only(topLeft: Radius.circular(50)),
  //         child: Container(
  //             padding: const EdgeInsets.all(10),
  //             color: Colors.white,
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   listHoursWeather.isNotEmpty
  //                       ? Expanded(
  //                           flex: 2,
  //                           child: ListView.builder(
  //                               scrollDirection: Axis.horizontal,
  //                               itemBuilder: ((context, index) {
  //                                 var meteo = listHoursWeather[index];
  //                                 return WeatherInformations(
  //                                     degrees: meteo.main.temp,
  //                                     hours: "${meteo.date.hour.toString()}h",
  //                                     pathImage:
  //                                         "assets/weather_icon/${listHoursWeather[index].weather[0].icon.substring(0, 2)}.png");
  //                               }),
  //                               itemCount: listHoursWeather.length),
  //                         )
  //                       : const Text(""),
  //                   rowInformations(),
  //                   weather5Days(),
  //                 ])),
  //       ));
  // }

  Row rowInformations() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Column(
            children: [
              DetailWeather(
                  information: "Lever du soleil",
                  value: displayHours(cityWeather.sunrise)),
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
                  information: "Coucher du soleil",
                  value: displayHours(cityWeather.sunset)),
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

  String displayHours(DateTime date) {
    String hours = (date.hour < 9) ? "0${date.hour}" : "${date.hour}";
    String minutes = (date.minute < 9) ? "0${date.minute}" : "${date.minute}";
    return "$hours:$minutes";
  }

  Widget weatherHours() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: listHoursWeather
            .map((weatherInfo) => WeatherInformations(
                  degrees: weatherInfo.main.feelsLike,
                  hours: "${weatherInfo.date.hour.toString()}h",
                  pathImage:
                      "assets/weather_icons/${weatherInfo.weather[0].icon}.png",
                ))
            .toList());
  }

  Widget weather5Days() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: list5DaysWeather
            .map((weatherInfo) => WeatherInformations(
                  degrees: weatherInfo.main.temp,
                  hours: getDay(weatherInfo.date.weekday),
                  pathImage:
                      "assets/weather_icons/${weatherInfo.weather[0].icon}.png",
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
                                onTap: () {
                                  changed = true;
                                  widget.myAppSettings.city.setValue(city.name);
                                  Navigator.pop(context);
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
