import '../lib/data/table/task_table.dart';
import '../lib/data/table/tag_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperForTesting {
  static Database? _database;

  static Future<Database> getInstance() async {
    _database ??= await openDatabase(inMemoryDatabasePath, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade, onConfigure: _onConfigure);
    return _database!;
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute(TaskTable.createQuery);
    await db.execute(TagTable.createQuery);
  }

  static Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    while(oldVersion < newVersion){
      oldVersion++;

      switch(oldVersion) {

      }
    }
  }

  static Future close() async {
    final db = await getInstance();
    db.close();
  }
}