import 'package:appli_meteo/bdd/database.dart';
import 'package:appli_meteo/models/meteo.dart';
import 'package:appli_meteo/services/meteo_service.dart';
import 'package:appli_meteo/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
    SqliteDB database = SqliteDB();
    await database.initDb();
    await database.fetchCities();
    Meteo cityWeather = await getCityWeather("Lyon");
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(cityWeather: cityWeather)));
    });
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
