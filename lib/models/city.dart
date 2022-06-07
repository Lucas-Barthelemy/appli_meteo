class City {
  String name;

  City(this.name);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    var city = City(map['name']);
    return city;
  }
}
