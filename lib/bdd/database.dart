import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';

import 'package:appli_meteo/models/city.dart';

class SqliteDB {
  late Database _db;

  Future<Database> get db async {
    return _db;
  }

  Future<int> insertCity(City city) async {
    return await _db.insert('cities', city.toMap());
  }

  void delete(City city) async {
    await _db.delete("cities", where: 'name = ?', whereArgs: [city.name]);
  }

  Future fetchCities() async {
    var results = await _db.query("cities");
    return results.map((e) => City.fromMap(e)).toList();
  }

  initDb() async {
    String path = join(await getDatabasesPath(), "database.db");
    _db = await openDatabase(path, version: 1);
    _db.execute(
        "CREATE TABLE IF NOT EXISTS cities (id INTEGER PRIMARY KEY, name TEXT)");
  }
}
