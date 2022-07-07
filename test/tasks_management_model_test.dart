import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tasks_management/model/task_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  late String jsonResponse;
  late Task taskToJson;
  late List<Tag> tags = [];

  group('Task Model', (){
    setUp((){
      jsonResponse = '{"taskId": "2a18802a-964c-4331-2118-08da5fde74a9","taskName": "Learn bootstrap","taskDescription": "Study Bootstrap","tag": [{"tagId": "2ad46418-706a-4ed7-53e9-08da5fde74b9","tagName": "Bootstrap","taskId": "2a18802a-964c-4331-2118-08da5fde74a9"},{"tagId": "b7f7e2e7-dc92-41d9-53ea-08da5fde74b9","tagName": "CSS Framework","taskId": "2a18802a-964c-4331-2118-08da5fde74a9"}],"dateCreated": "2022-07-07T00:00:00","dateModified": "2022-07-07T00:00:00","dateFinished": "2022-07-07T00:00:00" ,"status": 2}';
      tags.add(Tag(tagId: '2ad46418-706a-4ed7-53e9-08da5fde74b9', tagName: 'Bootstrap', taskId: '2a18802a-964c-4331-2118-08da5fde74a9'));
      tags.add(Tag(tagId: 'b7f7e2e7-dc92-41d9-53ea-08da5fde74b9', tagName: 'CSS Framework', taskId: '2a18802a-964c-4331-2118-08da5fde74a9'));
      taskToJson = Task(taskId: '2a18802a-964c-4331-2118-08da5fde74a9', taskName: 'Learn bootstrap', taskDescription: 'Study Bootstrap', tag: tags, dateCreated: "2022-07-07T00:00:00", dateModified: "2022-07-07T00:00:00", dateFinished: "2022-07-07T00:00:00", status: 2);
    });

    tearDown(() => tags.clear());

    test('Test TaskModel fromAPIJson and must return a task converted from Json', (){
      //Act
      final Task actualResult = Task.fromAPIJson(jsonDecode(jsonResponse));

      //Assert
      expect(actualResult.taskId, '2a18802a-964c-4331-2118-08da5fde74a9');
      expect(actualResult.taskName, 'Learn bootstrap');
      expect(actualResult.taskDescription, 'Study Bootstrap');
      expect(actualResult.status, 2);
      expect(actualResult.tag![0].tagName, 'Bootstrap');
      expect(actualResult.tag![1].tagName, 'CSS Framework');
      expect(actualResult.dateCreated, '2022-07-07T00:00:00');
      expect(actualResult.dateModified, '2022-07-07T00:00:00');
      expect(actualResult.dateFinished, '2022-07-07T00:00:00');
    });

    test('Test TaskModel toAPIJson and must return a task converted to Json', (){
      //Act
      final actualResult = taskToJson.toAPIJson();

      //Assert
      expect(actualResult, jsonDecode(jsonResponse));
    });
  });
}