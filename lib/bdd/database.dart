import 'package:sqflite/sqflite.dart';

class Database {
  static final Database _instance = new Database.internal();
  factory Database() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDb();
    return _db!;
  }

  Database.internal();

  initDb() async {}
}
