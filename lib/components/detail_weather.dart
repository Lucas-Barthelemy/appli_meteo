import 'package:flutter/widgets.dart';

class DetailWeather extends StatelessWidget {
  final String information, value;

  const DetailWeather(
      {super.key, required this.information, required this.value});

  @override
  Widget build(Object context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(information),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
