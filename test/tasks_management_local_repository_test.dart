import 'database_helper_for_testing.dart';
import 'package:tasks_management/model/task_model.dart';
import 'package:tasks_management/data/repository/local/local_tasks_repository.dart';
import 'package:tasks_management/data/table/task_table.dart';
import 'package:tasks_management/data/table/tag_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  late Database _database;
  late LocalTasksRepository _repository;
  
  setUpAll(() async {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
    _database = await DatabaseHelperForTesting.getInstance();
    _repository = LocalTasksRepository(_database);
  });

  tearDownAll(() async{
    await _database.close();
  });

  group('Database', (){
    group('Tasks Table', (){
      group('Create', (){
        late Task taskOne;
        late Task taskTwo;
        late Task taskThree;

        setUp(() async {
          //Make the table empty
          await _database.delete(TaskTable.tableName);

          taskOne = Task(taskId: "3aa55d00-583c-47d1-aac0-08da58503d81", taskName: "Learn UI/UX", taskDescription: "Read differences of UI/UX", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-01T00:00:00", dateFinished:  null , status: 0);
          taskTwo = Task(taskId: "d5daa405-85de-4218-d928-08da58d24927", taskName: "Learn Flutter", taskDescription: "Start learning flutter", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-01T00:00:00", dateFinished:  null , status: 0);
          taskThree = Task(taskId: "a2fb3f20-6440-4b7a-d929-08da58d24927", taskName: "Learn Bootstrap", taskDescription: "Bootstrap 5 Documentation", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-01T00:00:00", dateFinished:  null , status: 0);
        });
        
        tearDown(() async{
          await _database.delete(TaskTable.tableName);
        });

        test('Create a new task must insert the task in database and return its index', () async {
          final actualResultOne = await _repository.create(taskOne);
          final actualResultTwo = await  _repository.create(taskTwo);
          final actualResultThree = await _repository.create(taskThree);

          expect(actualResultOne, 1);
          expect(actualResultTwo, 2);
          expect(actualResultThree, 3);
        });
      });

      group('Read', (){
        late Task taskOne;
        late Task taskTwo;
        late Task taskThree;

        List<Task> tasks = [];

        setUp(() async {
          //Make sure if the table empty
          await _database.delete(TaskTable.tableName);

          taskOne = Task(taskId: "3aa55d00-583c-47d1-aac0-08da58503d81", taskName: "Learn UI/UX", taskDescription: "Read differences of UI/UX", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-01T00:00:00", dateFinished:  null , status: 0);
          taskTwo = Task(taskId: "d5daa405-85de-4218-d928-08da58d24927", taskName: "Learn Flutter", taskDescription: "Start learning flutter", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-01T00:00:00", dateFinished:  null , status: 0);
          taskThree = Task(taskId: "a2fb3f20-6440-4b7a-d929-08da58d24927", taskName: "Learn Bootstrap", taskDescription: "Bootstrap 5 Documentation", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-01T00:00:00", dateFinished:  null , status: 0);
        });

        tearDown(() async {
          await _database.delete(TaskTable.tableName);
        });

        test('Insert three tasks to database and get all tasks from the database and must return its count is equals to three', () async {
          // Insert Data
          await _repository.create(taskOne);
          await _repository.create(taskTwo);
          await _repository.create(taskThree);

          // Get all the data and get the count
          tasks = await _repository.getAllTasks();
          final actualResult = tasks.length;

          expect(actualResult, 3);
        });
      });

      group('Update', () {
        late Task taskOne;
        late Task taskOneUpdate;

        setUp(() async {
          //Make sure that table is empty
          await _database.delete(TaskTable.tableName);

          taskOne = Task(taskId: "3aa55d00-583c-47d1-aac0-08da58503d81", taskName: "Learn UI/UX", taskDescription: "Read differences of UI/UX", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-01T00:00:00", dateFinished:  null , status: 0);
          taskOneUpdate = Task(taskId: "3aa55d00-583c-47d1-aac0-08da58503d81", taskName: "Learn Bootstrap", taskDescription: "Read Bootstrap Documentation", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-06T00:00:00", dateFinished:  null , status: 1);
        });

        tearDown(() async {
          await _database.delete(TaskTable.tableName);
        });

        test('Insert a task and update it afterwards, return updated task matched to task to update', () async {
          //Insert task
          await _repository.create(taskOne);

          //Update Task
          final Task actualResult = await _repository.update(taskOneUpdate);

          //Used identical function to validate if the two objects has the same property values and will return a bool data type
          expect(identical(actualResult, taskOneUpdate), true);
        });

        test('Update the tasks status of created task and return true if the task is already updated', () async {
          //Insert task
          await _repository.create(taskOne);

          final bool actualResult = await _repository.updateTaskStatus(taskOne.taskId!, 2);

          expect(actualResult, true);
        });

      });

      group('Delete', (){
        late Task taskOne;

        setUp(() async {
          //Make sure that table is empty
          await _database.delete(TaskTable.tableName);

          taskOne = Task(taskId: "3aa55d00-583c-47d1-aac0-08da58503d81", taskName: "Learn UI/UX", taskDescription: "Read differences of UI/UX", dateCreated: "2022-07-01T00:00:00",dateModified: "2022-07-01T00:00:00", dateFinished:  null , status: 0);
        });

        tearDown(() async {
          await _database.delete(TaskTable.tableName);
        });

        test('Insert a task and delete it afterwards and must return deleted as true', () async {
          //Insert task
          await _repository.create(taskOne);

          //Delete Task
          final bool actualResult = await _repository.delete(taskOne.taskId!);

          expect(actualResult, true);
        });
      });
    });
  });
}

