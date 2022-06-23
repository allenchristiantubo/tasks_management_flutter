import 'package:flutter/material.dart';
import 'package:tasks_management/screens/dashboard_screen.dart';
import 'package:tasks_management/screens/tasks_screen.dart';
import 'package:tasks_management/shared/menu_bottom.dart';

class Task{
  String taskId;
  String taskName;
  String taskDescription;
  int status;
  DateTime dateCreated;

  Task(this.taskId, this.taskName, this.taskDescription, this.status, this.dateCreated);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch:Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: MenuBottom(),
    );
  }
}
