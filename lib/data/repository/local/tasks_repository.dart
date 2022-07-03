import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../../../model/task_model.dart';
import '../../table/task_table.dart';
import '../../table/tag_table.dart';
import '../../services/database_helper.dart';

class TasksRepository{

  Future create(Task task) async {
    final db = await DatabaseHelper.getInstance();
    Batch batch = db.batch();
    batch.insert(TaskTable.tableName, task.toLocalJson());
    if(task.tag != null){
      for(var tag in task.tag!){
        batch.insert(TagTable.tableName, tag.toJson());
      }
    }
    await batch.commit(noResult: true);
  }
  //
  // Future delete(String id) async {
  //   final db = await DatabaseHelper.getInstance();
  //   await db.delete(TaskTable.tableName, where: 'taskId = ?' , whereArgs: [id]);
  // }
  //
  // Future updateTaskStatus(String id, int status) async{
  //   final db = await DatabaseHelper.getInstance();
  //   await db.update(TaskTable.tableName, {'status': status}, where: 'taskId = ?', whereArgs: [id]);
  // }
  //
  // Future getAllTasks() async{
  //   final db = await DatabaseHelper.getInstance();
  //   List<Map> tasks = await db.query(TaskTable.tableName);
  //   debugPrint(tasks.toString());
  // }
}