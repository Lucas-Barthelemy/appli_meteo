class City {
  int id;
  String name;

  City(this.id, this.name);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    var city = City(map['id'], map['name']);
    return city;
  }
}
