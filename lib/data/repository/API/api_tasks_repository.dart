import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../model/task_model.dart';

class APITasksRepository{

  //final String _authority = "10.0.2.2:7100";
  //final String _unencodedPath = "api/tasks";

  Map<String, String> get requestHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Headers':'Content-Type',
    'X-Skip-Interceptor': 'X-Skip-Interceptor'
  };

  Future<List<Task>?> getAllTasks() async {
    var client = http.Client();
    var uri = Uri.parse("https://10.0.2.2:7100/api/tasks");
    List<Task> tasks = [];
    http.Response response = await client.get(uri, headers: requestHeaders);

    if(response.statusCode == 200){
      final json =  jsonDecode(response.body);
      for(Map<String, dynamic> task in json){
        tasks.add(Task.fromAPIJson(task));
      }
      return tasks;
    }
    return null;
  }

  Future<Task?> getTaskById(String id) async {
    var client = http.Client();
    var uri = Uri.parse("https://10.0.2.2:7100/api/tasks/$id");
    http.Response response = await client.get(uri, headers: requestHeaders);

    if(response.statusCode == 200){
      Map<String, dynamic> data = jsonDecode(response.body);
      return Task.fromAPIJson(data);
    }
    return null;
  }

  Future<int> getTasksCountPerStatus(int status) async {
    var client = http.Client();
    var uri = Uri.parse("https://10.0.2.2:7100/api/tasks/count/$status");
    http.Response response = await client.get(uri, headers: requestHeaders);

    if(response.statusCode == 200){
      return int.parse(response.body);
    }
    return 0;
  }

  Future createTask(Task newTask) async {
    var client = http.Client();
    var uri = Uri.parse("https://10.0.2.2:7100/api/tasks");

    final body = jsonEncode(newTask.toAPIJson());
    http.Response response = await client.post(uri, body: body, headers: requestHeaders);

    //Response for task created
    if(response.statusCode == 201){
     Map<String, dynamic> data = jsonDecode(response.body);
      return Task.fromAPIJson(data);
    }
  }

  Future updateTask(Task taskToUpdate) async{
    var client = http.Client();
    final taskId = taskToUpdate.taskId;
    var uri = Uri.parse("https://10.0.2.2:7100/api/tasks/$taskId");
    final body = jsonEncode(taskToUpdate.toAPIJson());

    http.Response response = await client.put(uri, body: body, headers: requestHeaders);

    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      return Task.fromAPIJson(json);
    }
  }

  Future updateStatus(String taskId, int status) async {
    final client = http.Client();
    final uri = Uri.parse("https://10.0.2.2:7100/api/tasks/update/status/$taskId?status=$status");

    http.Response response = await client.put(uri, headers:requestHeaders);

    if(response.statusCode == 200){
      Map<String, dynamic> json = jsonDecode(response.body);
      return Task.fromAPIJson(json);
    }
  }

  Future deleteTask(String id) async {
    var client = http.Client();
    var uri = Uri.parse("https://10.0.2.2:7100/api/tasks/$id");

    http.Response response = await client.delete(uri, headers: requestHeaders);

    //Response status code for No Content
    if(response.statusCode == 204){
      return true;
    }
  }

}