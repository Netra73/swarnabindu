import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 5;

  static final table = 'my_table';

  static final cardNumber = '_id';
  static final childName = 'name';
  static final age = 'age';
  static final mobileNumb = 'mob';
  static final childCond = 'cond';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null){
      print("Database exist");
      return _database;
    } else {
      print("Database not exist");
      _database = await _initDatabase();
      return _database;
    }
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE customer (
            cid INTEGER PRIMARY KEY AUTOINCREMENT,
            card VARCHAR(255),
            taluk VARCHAR(255),
            camp VARCHAR(255),
            campName VARCHAR(255),
            capm_type VARCHAR(255),
            name VARCHAR(255),
            age VARCHAR(255),
            mobile VARCHAR(255),
            ctype VARCHAR(255))
          ''');

  }

  Future<List<Map<String, dynamic>>> getMaster() async {
    Database db = await instance.database;
    return await db.query("sqlite_master");
  }

  Future<int> saveCustomer(body) async {
    Map<String, dynamic> row = {
      "card":body['card'],
      "taluk":body['taluk'],
      "camp":body['camp'],
      "campName":body['campname'],
      "capm_type":body['camptype'],
      "name":body['name'],
      "age":body['age'],
      "mobile":body['mobile'],
      "ctype":body['ctype'],
    };
    Database db = await instance.database;
    return await db.insert("customer", row);
  }

  Future<List<Map<String, dynamic>>> getCustomer() async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT * FROM customer");
  }

  Future<List<Map<String, dynamic>>> getPendingCount() async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT COUNT(cid) AS total,campName,camp FROM customer GROUP BY campName");
  }

  Future<List<Map<String, dynamic>>> deleteCustomer(String ids,String camp) async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM customer WHERE camp='"+camp+"' AND cid NOT IN ($ids)");
  }

  Future<List<Map<String, dynamic>>> getCampCustomer(String camp) async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT * FROM customer WHERE camp='"+camp+"'");
  }

  Future<List<Map<String, dynamic>>> getSingleCustomer(String cid) async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT * FROM customer WHERE cid='"+cid+"'");
  }

  Future<List<Map<String, dynamic>>> deleteSingleCustomer(String cid) async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM customer WHERE cid='"+cid+"'");
  }

  Future<List<Map<String, dynamic>>> clearCamp(String camp) async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM customer WHERE camp='"+camp+"'");
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[cardNumber];
    return await db.update(table, row, where: '$cardNumber = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$cardNumber = ?', whereArgs: [id]);
  }
}