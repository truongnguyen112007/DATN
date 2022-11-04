import 'dart:math';

import 'package:base_bloc/data/model/places_model.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String tableDoctor = 'doctors';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const namePlace = 'TEXT NOT NULL';
    const nameCity = 'TEXT NOT NULL';
    const distance = 'DOUBLE NOT NULL';
    const lat = 'DOUBLE NOT NULL';
    const lng = 'DOUBLE NOT NULL';

    await db.execute('''
CREATE TABLE $tableDoctor ( 
  ${PlaceField.id} $idType, 
  ${PlaceField.namePlace} $namePlace,
  ${PlaceField.nameCity} $nameCity,
  ${PlaceField.distance} $distance,
  ${PlaceField.lat} $lat,
  ${PlaceField.lng} $lng  )
''');
  }

  Future<void> create(PlacesModel model) async {
    await delete(model.nameCity.toString());
    final db = await instance.database;
    await db.insert(tableDoctor, model.toJson());
  }

  Future<PlacesModel?> readDoctor(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDoctor,
      columns: PlaceField.values,
      where: '${PlaceField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PlacesModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<void> removeAllData() async {
    final db = await instance.database;
    db.rawDelete('DELETE FROM $tableDoctor');
  }

  Future<List<PlacesModel>> readAllPlace() async {
    final db = await instance.database;
    final result = await db.rawQuery(
        "SELECT DISTINCT ${PlaceField.id},${PlaceField.namePlace},${PlaceField.nameCity},${PlaceField.distance},${PlaceField.lng},${PlaceField.lat}  FROM $tableDoctor ORDER BY ${PlaceField.id} DESC LIMIT 5");
    return result.map((json) => PlacesModel.fromJson(json)).toList();
  }

  Future<int> update(PlacesModel doctor) async {
    final db = await instance.database;
    return db.update(
      tableDoctor,
      doctor.toJson(),
      where: '${PlaceField.id} = ?',
      whereArgs: [doctor.idType],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableDoctor,
      where: '${PlaceField.nameCity} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

class PlaceField {
  static final List<String> values = [
    id,
    namePlace,
    nameCity,
    distance,
    lat,
    lng
  ];
  static const String id = '_id';
  static const String namePlace = 'namePlace';
  static const String nameCity = 'nameCity';
  static const String distance = 'distance';
  static const String lat = 'lat';
  static const String lng = 'lng';
}
