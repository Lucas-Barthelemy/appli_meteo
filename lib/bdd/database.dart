import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';

import '../models/city.dart';

class SqliteDB {
  late Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<int> insertCity(City city) async {
    return await _db.insert('cities', city.toMap());
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
