class Meteo {
  int? id;
  String? name;
  List<Weather> weather;
  Main main;
  Sys? sys;
  Wind? wind;
  DateTime? date;

  Meteo(this.id, this.name, this.weather, this.main, this.sys, this.wind,
      this.date);
}

class Weather {
  int id;
  String main, description, icon;

  Weather(this.id, this.main, this.description, this.icon);
}

class Main {
  int pressure, humidity;
  double temp, tempMin, tempMax;

  Main(this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax);
}

class Sys {
  int type, id, sunrise, sunset;
  String country;

  Sys(this.type, this.id, this.country, this.sunrise, this.sunset);
}

class Wind {
  double speed;

  Wind(this.speed);
}
