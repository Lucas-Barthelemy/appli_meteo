import 'package:appli_meteo/services/meteo_service.dart';
import 'package:appli_meteo/utils/variables.dart';
import 'package:appli_meteo/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'models/meteo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
    Meteo cityWeather = await getCityWeather("Lyon");
    List<Meteo> city5DaysWeather = await getCity5DaysWeather("Lyon");
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                  cityWeather: cityWeather,
                  city5DaysWeather: city5DaysWeather)));
    });
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
