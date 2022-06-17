import 'package:appli_meteo/models/meteo.dart';

String getDay(int day) {
  switch (day) {
    case 1:
      return "Lun";
    case 2:
      return "Mar";
    case 3:
      return "Mer";
    case 4:
      return "Jeu";
    case 5:
      return "Ven";
    case 6:
      return "Sam";
    case 7:
      return "Dim";
    default:
      return "";
  }
}

bool isNight(Meteo meteo) {
  if (meteo.date.isAfter(meteo.sunrise) && meteo.date.isBefore(meteo.sunset)) {
    return false;
  }
  return true;
}
