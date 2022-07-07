import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:tasks_management/data/repository/API/api_tasks_repository.dart';
import 'package:tasks_management/model/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAPIRepository extends Mock implements APITasksRepository {}

void main() {
  late MockAPIRepository _mockAPIRepository;
  late Task taskOne;
  late Task taskOneUpdate;
  late Task taskTwo;
  late Tag tagOne;
  late Tag tagTwo;
  late String jsonReturn;
  List<Task> tasks = [];
  List<Task> returnedTasks = [];
  List<Tag> tags = [];

  setUpAll((){
  _mockAPIRepository = MockAPIRepository();
  });

  tearDownAll((){

  });

  group('Tasks', () {

    group('Create a task Request', (){

      setUp((){
        tagOne = Tag(tagName: "Bootstrap");
        tagTwo = Tag(tagName: "CSS Framework");
        tags.add(tagOne);
        tags.add(tagTwo);

        taskOne = Task(taskName: "Learn bootstrap", taskDescription: "Study Bootstrap", status:  0, tag:tags);
        jsonReturn = jsonEncode(taskOne.toAPIJson());
      });

      tearDown((){
        tags.clear();
      });

      test('Insert a task and must return a task and match to inputted task', () async {
        when(() => _mockAPIRepository.createTask(taskOne))
            .thenAnswer((_) {
           return Future<Task>.value(
             Task.fromAPIJson(jsonDecode(jsonReturn))
           );
        });

        //Act
        final Task actualResult = await _mockAPIRepository.createTask(taskOne);

        //Assert
        expect(actualResult.taskName, taskOne.taskName);
        expect(actualResult.taskDescription, taskOne.taskDescription);
        expect(actualResult.status, taskOne.status);
        for(var index = 0; index < actualResult.tag!.length; index++){
          expect(actualResult.tag![index].tagName, taskOne.tag![index].tagName);
        }

      });

    });

    group('Get all tasks request', () {
      setUp((){
        tagOne = Tag(tagName: "Bootstrap");
        tagTwo = Tag(tagName: "CSS Framework");
        tags.add(tagOne);
        tags.add(tagTwo);
        taskOne = Task(taskName: "Learn bootstrap", taskDescription: "Study Bootstrap", status:  0, tag:tags);
        tasks.add(taskOne);
        tags.clear();


        tagOne = Tag(tagName: "Flutter");
        tagTwo = Tag(tagName: "Mobile Development");
        taskTwo = Task(taskName: "Learn flutter", taskDescription: "Read flutter documentation", status:  2, tag:tags);
        tasks.add(taskTwo);
        tags.clear();
      });

      tearDown((){
        tags.clear();
        tasks.clear();
        returnedTasks.clear();
      });

      test('Get all tasks and must return a list of tasks and match the tasks count and tasks property value', () async {
        when(() => _mockAPIRepository.getAllTasks())
            .thenAnswer((_) {
              jsonReturn = jsonEncode(taskOne.toAPIJson());
              returnedTasks.add(Task.fromAPIJson(jsonDecode(jsonReturn)));
              jsonReturn = jsonEncode(taskTwo.toAPIJson());
              returnedTasks.add(Task.fromAPIJson(jsonDecode(jsonReturn)));
              return Future<List<Task>?>.value(
                returnedTasks
              );
        });

        //Act
        final List<Task>? actualResult = await _mockAPIRepository.getAllTasks();

        //Assert
        if(actualResult != null){
          expect(actualResult.length, tasks.length);
          for(var index = 0; index < actualResult.length; index++){
            expect(actualResult[index].taskName, tasks[index].taskName);
            expect(actualResult[index].taskDescription, tasks[index].taskDescription);
            expect(actualResult[index].status, tasks[index].status);
            for(var tagIndex = 0; tagIndex < actualResult[index].tag!.length; tagIndex++)
            {
              expect(actualResult[index].tag![tagIndex].tagName, tasks[index].tag![tagIndex].tagName);
            }
          }
        }
      });

      test('Get all tasks and must return an empty list if there is no data found', () async{
        when(() => _mockAPIRepository.getAllTasks())
            .thenAnswer((_) {
          return Future<List<Task>?>.value(
              returnedTasks
          );
        });

        //Act
        final List<Task>? actualResult = await _mockAPIRepository.getAllTasks();

        //Assert
        expect(actualResult, []);

      });

    });

    group('Update a task Request', (){
      setUp((){
        tagOne = Tag(tagName: "UI/UX");
        tagTwo = Tag(tagName: "Mobile Development");
        tags.add(tagOne);
        tags.add(tagTwo);
        taskOne = Task(taskName: "Learn UI/UX", taskDescription: "Read differences of UI/UX", status: 0, tag:tags);
        tags.clear();

        tagOne = Tag(tagName: "Bootstrap");
        tagTwo = Tag(tagName: "CSS Framework");
        tags.add(tagOne);
        tags.add(tagTwo);
        taskOneUpdate = Task(taskName: "Learn Bootstrap", taskDescription: "Read Bootstrap Documentation",  status: 1, tag: tags);
        tags.clear();

        jsonReturn = jsonEncode(taskOneUpdate.toAPIJson());
      });

      tearDown((){
        tags.clear();
      });

      test('Update a task and return an updated task and must be matched with inputted task', () async {
        when(() => _mockAPIRepository.createTask(taskOne))
            .thenAnswer((_) {
          return Future<Task>.value(
              Task.fromAPIJson(jsonDecode(jsonReturn))
          );
        });

        when(() => _mockAPIRepository.updateTask(taskOneUpdate))
            .thenAnswer((_) {
          return Future<Task>.value(
              Task.fromAPIJson(jsonDecode(jsonReturn))
          );
        });

        //Arrange
        final Task taskCreated  = await _mockAPIRepository.createTask(taskOne);
        taskOneUpdate.taskId = taskCreated.taskId;

        //Act
        final Task actualResult = await _mockAPIRepository.updateTask(taskOneUpdate);

        //Assert

        //Checking here if the actualResult got the dateCreated of task when it was created.
        expect(actualResult.dateCreated, taskCreated.dateCreated);

        //Checking if actualResult has the updated task
        expect(actualResult.taskId, taskOneUpdate.taskId);
        expect(actualResult.taskName, taskOneUpdate.taskName);
        expect(actualResult.taskDescription, taskOneUpdate.taskDescription);
        expect(actualResult.status, taskOneUpdate.status);

        for(var index = 0; index < actualResult.tag!.length; index++){
          //Checking if the tag name of created task and updated task does not match.
          expect(actualResult.tag![index].tagName, isNot(equals(taskOne.tag![index].tagName)));
          expect(actualResult.tag![index].tagId, isNot(equals(taskOne.tag![index].tagId)));
        }

      });
    });

    group('Delete a task Request', (){
      setUp((){
        taskOne = Task(taskName: "Learn UI/UX", taskDescription: "Read differences of UI/UX", status: 0, tag:tags);
      });

      test('Delete a task and return a true value if it is deleted', () async {
        //Arrange
        when(() => _mockAPIRepository.createTask(taskOne))
            .thenAnswer((_) {
          return Future<Task>.value(
              Task.fromAPIJson(jsonDecode(jsonReturn))
          );
        });

        when(() => _mockAPIRepository.deleteTask(any(that: isNotNull)))
            .thenAnswer((_) {
              return Future.value(
                true
              );
        });
        final Task createdTask = await _mockAPIRepository.createTask(taskOne);

        //Act
        final bool actualResult = await _mockAPIRepository.deleteTask(createdTask.taskId.toString());

        //Assert
        expect(actualResult, true);
      });
    });
  });
}