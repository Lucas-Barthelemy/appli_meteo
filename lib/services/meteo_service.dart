import 'dart:convert';

import 'package:appli_meteo/models/meteo.dart';
import 'package:http/http.dart' as http;

Future<Meteo> getCityWeather(String name) async {
  Meteo meteo = Meteo(0, "", [], Main(0, 0, 0, 0, 0));

  // https://api.openweathermap.org/data/2.5/weather?q=London&appid={API key}

  var uri = Uri.https("api.openweathermap.org", "/data/2.5/weather",
      {"q": name, "appid": "841df294d282a84958d22be38fc1800f"});
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    List<Weather> listWeather = convertToWeather(jsonResponse["weather"]);
    Main main = convertToMain(jsonResponse["main"]);
    meteo = Meteo(jsonResponse["id"], jsonResponse["name"], listWeather, main);
  } else {
    // ignore: avoid_print
    print("Request failed with status: ${response.statusCode}");
  }

  return meteo;
}

List<Weather> convertToWeather(List<dynamic> dynamic) {
  List<Weather> listWeather = [];
  Weather weather = Weather(dynamic[0]["id"], dynamic[0]["main"],
      dynamic[0]["description"], dynamic[0]["icon"]);
  listWeather.add(weather);
  return listWeather;
}

Main convertToMain(dynamic dynamic) {
  return Main(dynamic["temp"], dynamic["pressure"], dynamic["humidity"],
      dynamic["temp_min"], dynamic["temp_max"]);
}
