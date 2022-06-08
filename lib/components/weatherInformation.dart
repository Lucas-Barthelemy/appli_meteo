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
            Text(hours.toString()),
            const SizedBox(height: 5),
            Image.asset(pathImage, height: 50, width: 50),
            const SizedBox(height: 10),
            Text(degrees.toString() + "°",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
    );
  }
}
