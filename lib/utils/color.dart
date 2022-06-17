import 'package:flutter/material.dart';

Color getColor(String icon) {
  switch (icon) {
    // Soleil
    case "01d":
      return Colors.red;
    case "01n":
      return Colors.indigo.shade800;
    // Ombragé
    case "02d":
    case "02n":
      return Colors.grey;
    // Nuageux
    case "03d":
    case "03n":
      return Colors.grey;
    // Nuageux noir
    case "04d":
    case "04n":
      return const Color.fromARGB(255, 74, 72, 72);
    // Bruine
    case "09d":
    case "09n":
      return Colors.blueGrey;
    // Pluie
    case "10d":
    case "10n":
      return Colors.lightBlue;
    // Orage
    case "11d":
    case "11n":
      return Colors.black;
    // Neige
    case "13d":
    case "13n":
      return Colors.blue.shade50;
    // Brouillard
    case "50d":
    case "50n":
      return Colors.grey.shade300;
    default:
      return Colors.green;
  }
}
