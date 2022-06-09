import 'dart:convert';

import 'package:appli_meteo/models/meteo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Meteo> getCityWeather(String name) async {
  Meteo meteo = Meteo(0, "", [], Main(0, 0, 0, 0, 0, 0), Wind(0.0),
      DateTime(2022), DateTime(2022), DateTime(2022));

  // https://api.openweathermap.org/data/2.5/weather?q={ville}&appid={API key}

  var uri = Uri.https("api.openweathermap.org", "/data/2.5/weather", {
    "q": name,
    "units": "metric",
    "lang": "fr",
    "appid": dotenv.env["API_KEY"],
  });
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    List<Weather> listWeather = convertToWeather(jsonResponse["weather"]);
    Main main = convertToMain(jsonResponse["main"]);
    Wind wind = convertToWind(jsonResponse["wind"]);
    DateTime date =
        convertToLocalHour(jsonResponse["dt"], jsonResponse["timezone"]);
    DateTime sunrise = convertToLocalHour(
        jsonResponse["sys"]["sunrise"], jsonResponse["timezone"]);
    DateTime sunset = convertToLocalHour(
        jsonResponse["sys"]["sunset"], jsonResponse["timezone"]);
    meteo = Meteo(jsonResponse["id"], jsonResponse["name"], listWeather, main,
        wind, date, sunrise, sunset);
  } else {
    // ignore: avoid_print
    print("Request failed with status: ${response.statusCode}");
  }

  return meteo;
}

Future<List<Meteo>> getCity5DaysWeather(String name) async {
  List<Meteo> list5DaysWeather = [];

  // https://api.openweathermap.org/data/2.5/forecast?q={ville}&appid={key}
  var uri = Uri.https("api.openweathermap.org", "/data/2.5/forecast", {
    "q": name,
    "units": "metric",
    "lang": "fr",
    "appid": dotenv.env["API_KEY"],
  });
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    for (var data in jsonResponse["list"]) {
      List<Weather> listWeather = convertToWeather(data["weather"]);
      Main main = convertToMain(data["main"]);
      Wind wind = convertToWind(data["wind"]);
      DateTime date =
          convertToLocalHour(data["dt"], jsonResponse["city"]["timezone"]);
      DateTime sunrise = convertToLocalHour(
          jsonResponse["city"]["sunrise"], jsonResponse["city"]["timezone"]);
      DateTime sunset = convertToLocalHour(
          jsonResponse["city"]["sunset"], jsonResponse["city"]["timezone"]);
      Meteo meteo =
          Meteo(null, null, listWeather, main, wind, date, sunrise, sunset);
      list5DaysWeather.add(meteo);
    }
  } else {
    // ignore: avoid_print
    print("Request failed with status: ${response.statusCode}");
  }
  return list5DaysWeather;
}

List<Weather> convertToWeather(List<dynamic> dynamic) {
  List<Weather> listWeather = [];
  Weather weather = Weather(dynamic[0]["id"], dynamic[0]["main"],
      dynamic[0]["description"], dynamic[0]["icon"]);
  listWeather.add(weather);
  return listWeather;
}

Main convertToMain(dynamic dynamic) {
  return Main(
      dynamic["temp"].toDouble(),
      dynamic["pressure"],
      dynamic["humidity"],
      dynamic["temp_min"].toDouble(),
      dynamic["temp_max"].toDouble(),
      dynamic["feels_like"].toDouble());
}

DateTime convertToDateTime(String date) {
  return DateTime.parse(date);
}

DateTime convertToLocalHour(dynamic dt, dynamic timezone) {
  return DateTime.fromMillisecondsSinceEpoch(
      (dt.toInt() + timezone.toInt()) * 1000,
      isUtc: true);
}

Wind convertToWind(dynamic dynamic) {
  return Wind(dynamic["speed"].toDouble());
}
