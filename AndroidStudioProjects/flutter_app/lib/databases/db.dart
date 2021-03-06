import 'dart:async';
import 'package:flutter_app/models/model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {

  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'example';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE categories (id INTEGER PRIMARY KEY NOT NULL, name STRING, description STRING, monthlyBudget REAL)');
    await db.execute('CREATE TABLE entries (id INTEGER PRIMARY KEY NOT NULL, category STRING, entry STRING, amount REAL)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async =>
      await _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

  static Future getTotalEntries(String categoryName) async {
    List<Map> list = await _db.rawQuery('SELECT SUM(amount) FROM entries');
    print(list[0].values);
    returnResults(list[0].values.toString());
  }

  static String returnResults(String results) {
    return results;
  }

}