/*import 'dart:developer';

import 'package:aquacalc/entity/pipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepository {
  static const String _id = 'id';
  static const String _description = 'description';
  static const String _note = 'note';
  static const String _calcmode = 'calcmode';
  static const String _tableName = 'Measurements';
  static const String _date = 'date';
  static const String _result = 'result';

  static Database? _database;

  static Future<void> initDatabase() async {
    if (_database != null) return;

    _database = await _initDB('measurementsdb_120.db');
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      create table $_tableName ( 
        $_id integer primary key  , 
        $_description string,
        $_date string,
        $_note string,
        $_calcmode string,
        $_result double )
      ''');
  }

  static Future<int> delete(int id) async {
    Database db = _database!;
    var result = await db.rawDelete("delete from Measurements where id = $id");
    return result;
  }

  static Future<int> update(Measurements product) async {
    Database db = _database!;
    var result = await db.update("Measurements", product.toMap(),
        where: "id=?", whereArgs: [product.id]);
    return result;
  }

  static Future<int> insert(int id,
  String calcMode, String description, String note,
      double result, String date) async {
    Database db = _database!;
    var results;

    Measurements obj = Measurements(id,description, result, note, calcMode, date);
      log(id.toString());
    results = await db.insert("Measurements", obj.toMap());

    return results;
  }

  static Future<List<Measurements>> getProducts() async {
    Database db = _database!;
    var result = await db.query("Measurements");

    return List.generate(result.length, (index) {
      return Measurements(
        result[index]["id"] as int,
        result[index]["description"] as String,
        result[index]["result"] != null ? result[index]["result"] as double : 0,
        result[index]["note"] as String ,
        result[index]["calcmode"] as String,
        result[index]["date"] as String,
      );
    });
  }
}
*/