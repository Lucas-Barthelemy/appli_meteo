class Meteo {
  int? id;
  String? name;
  List<Weather> weather;
  Main main;
  Wind? wind;
  DateTime date;
  DateTime sunrise;
  DateTime sunset;

  Meteo(this.id, this.name, this.weather, this.main, this.wind, this.date,
      this.sunrise, this.sunset);
}

class Weather {
  int id;
  String main, description, icon;

  Weather(this.id, this.main, this.description, this.icon);
}

class Main {
  int pressure, humidity;
  double temp, tempMin, tempMax, feelsLike;

  Main(this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax,
      this.feelsLike);
}

class Wind {
  double speed;

  Wind(this.speed);
}
