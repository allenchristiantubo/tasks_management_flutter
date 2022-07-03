import '../table/task_table.dart';
import '../table/tag_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static Database? _database;

  static Future<Database> getInstance() async {
    _database ??= await _initDb('TasksManager.sqlite');
    return _database!;
  }

  static Future<Database> _initDb(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute(TaskTable.createQuery);
    await db.execute(TagTable.createQuery);
  }

  static Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static Future _addColumn(String tableName, String columnName, String dataType, Database db) async {
    final sqlPragma = "PRAGMA table_info($tableName)";
    final result = await db.rawQuery(sqlPragma);

    if(result.isNotEmpty){
      for(Map<String,dynamic> existingColumn in result){
        if(existingColumn['name'] == columnName){
          return;
        }
      }

      final sqlAlter = "ALTER TABLE $tableName ADD COLUMN $columnName $dataType";
      await db.execute(sqlAlter);
    }
    else{
      return;
    }
  }

  static Future close() async {
    final db = await getInstance();
    db.close();
  }
}