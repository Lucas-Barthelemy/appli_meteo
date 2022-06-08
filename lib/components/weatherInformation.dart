import 'package:flutter/widgets.dart';

class WeatherInformations extends StatelessWidget {
  final double degrees;
  final String hours;
  final String pathImage;
  const WeatherInformations(this.degrees, this.hours, this.pathImage);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(hours),
            const SizedBox(height: 5),
            Image.asset(pathImage, height: 40, width: 40),
            const SizedBox(height: 10),
            Text(degrees.toStringAsFixed(0) + "°",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
    );
  }
}
