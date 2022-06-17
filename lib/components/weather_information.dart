import 'package:flutter/widgets.dart';

class WeatherInformations extends StatelessWidget {
  const WeatherInformations(
      {Key? key,
      required this.degrees,
      required this.hours,
      required this.pathImage})
      : super(key: key);
  final double degrees;
  final String hours;
  final String pathImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(hours),
            const SizedBox(height: 5),
            Image.asset(pathImage, height: 40, width: 40),
            const SizedBox(height: 10),
            Text("${degrees.toStringAsFixed(0)}°",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
    );
  }
}
