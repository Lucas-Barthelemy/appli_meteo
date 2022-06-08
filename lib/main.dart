import 'package:appli_meteo/services/meteo_service.dart';
import 'package:appli_meteo/utils/variables.dart';
import 'package:appli_meteo/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'models/meteo.dart';

class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : city = preferences.getString('city', defaultValue: "Paris");

  final Preference<String> city;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await StreamingSharedPreferences.instance;
  final settings = MyAppSettings(preferences);

  runApp(MyApp(myAppSettings: settings));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.myAppSettings}) : super(key: key);
  MyAppSettings myAppSettings;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(myAppSettings: myAppSettings),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.myAppSettings}) : super(key: key);
  MyAppSettings myAppSettings;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await database.initDb();
    Meteo cityWeather =
        await getCityWeather(widget.myAppSettings.city.getValue());
    List<Meteo> city5DaysWeather =
        await getCity5DaysWeather(widget.myAppSettings.city.getValue());
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                  cityWeather: cityWeather,
                  city5DaysWeather: city5DaysWeather,
                  myAppSettings: widget.myAppSettings)));
    });
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
