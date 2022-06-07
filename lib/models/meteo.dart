class Meteo {
  int? id;
  String? name;
  List<Weather> weather;
  Main main;
  DateTime? date;

  Meteo(this.id, this.name, this.weather, this.main, this.date);
}

class Weather {
  int id;
  String main, description, icon;

  Weather(this.id, this.main, this.description, this.icon);
}

class Main {
  int pressure, humidity;
  double temp, temp_min, temp_max;

  Main(this.temp, this.pressure, this.humidity, this.temp_min, this.temp_max);
}
