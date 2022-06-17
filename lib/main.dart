import 'package:appli_meteo/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : city = preferences.getString('city', defaultValue: "Lyon");

  final Preference<String> city;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final preferences = await StreamingSharedPreferences.instance;
  final settings = MyAppSettings(preferences);

  runApp(MyApp(myAppSettings: settings));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.myAppSettings}) : super(key: key);
  final MyAppSettings myAppSettings;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: HomePage(myAppSettings: myAppSettings),
      debugShowCheckedModeBanner: false,
    );
  }
}
