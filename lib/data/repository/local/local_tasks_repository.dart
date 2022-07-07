import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../../../model/task_model.dart';
import '../../table/task_table.dart';
import '../../table/tag_table.dart';
import '../../services/database_helper.dart';

class LocalTasksRepository{
  late Database _database;

  LocalTasksRepository(Database database){
    _database = database;
  }

  Future create(Task task) async {
    Batch batch = _database.batch();
    batch.insert(TaskTable.tableName, task.toLocalJson());
    if(task.tag != null){
      for(var tag in task.tag!){
        batch.insert(TagTable.tableName, tag.toJson());
      }
    }
    var result = await batch.commit();
    return result[0];
  }

  Future delete(String id) async {
   var result = await _database.delete(TaskTable.tableName, where: 'taskId = ?' , whereArgs: [id]);
   return result == 1 ? true : false;
  }

  Future updateTaskStatus(String id, int status) async{
    var result = await _database.update(TaskTable.tableName, {'status': status}, where: 'taskId = ?', whereArgs: [id]);
    return result == 1 ? true : false;
  }

  Future update(Task task) async {
    Batch batch = _database.batch();
    batch.update(TaskTable.tableName, task.toLocalJson(), where: 'taskId = ?', whereArgs: [task.taskId]);
    if(task.tag != null){
      batch.delete(TagTable.tableName, where: 'taskId = ?', whereArgs: [task.taskId]);
      for(var tag in task.tag!){
        batch.insert(TagTable.tableName, tag.toJson());
      }
    }
    var result = await batch.commit();
    if(result.isNotEmpty){
       return task;
    }
  }

  Future getAllTasks() async{
    List<Task> tasks = [];

    var tasksFromDB = await _database.query(TaskTable.tableName);
    for(var taskData in tasksFromDB){
      List<Tag> tags = [];
      Task task = (Task.fromLocalJson(taskData));
      var tagsFromDb = await _database.query(TagTable.tableName, where: 'taskId = ?', whereArgs: [task.taskId]);
      for(var tagsData in tagsFromDb){
        Tag tag = (Tag.fromJson(tagsData));
        tags.add(tag);
      }
      task.tag = tags;
      tasks.add(task);
    }
    return tasks;
  }
}