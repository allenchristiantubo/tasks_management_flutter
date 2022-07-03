import 'dart:convert';

import 'package:intl/intl.dart';

class Task{
  String? taskId = "";
  String taskName = "";
  String taskDescription = "";
  String? dateCreated = "";
  String? dateModified = "";
  String? dateFinished = "";
  int status = 0;
  List<Tag>? tag = [];

  //Constructor of task
  Task({
    this.taskId,
    required this.taskName,
    required this.taskDescription,
    this.dateCreated,
    this.dateModified,
    this.dateFinished,
    required this.status,
    this.tag
  });

  Task.fromAPIJson(Map<String, dynamic> data){
    taskId = data['taskId'];
    taskName = data['taskName'];
    taskDescription = data['taskDescription'];
    dateCreated = data['dateCreated'];
    dateModified = data['dateModified'];

    if(data['dateFinished'] != null){
      dateFinished = data['dateFinished'];
    }

    status = data['status'];

    for(Map<String, dynamic> tagValue in data['tag']){
      tag!.add(Tag.fromJson(tagValue));
    }
  }

  Map<String, dynamic> toAPIJson(){
    final Map<String,dynamic> data = <String,dynamic>{};

    if(taskId != null){
      data['taskId'] = taskId;
    }

    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;

    if(dateCreated != null){
      data['dateCreated'] = dateCreated;
    }

    if(dateModified != null){
      data['dateModified'] = dateModified;
    }

    if(dateFinished != null){
      data['dateFinished'] = dateFinished;
    }

    data['status'] = status;

    if(tag != null){
      data['tag'] = tag!.map((value) => value.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toLocalJson(){
    final Map<String, dynamic> data = <String,dynamic>{};
    if(taskId != null){
      data['taskId'] = taskId;
    }

    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;

    if(dateCreated != null){
      data['dateCreated'] = dateCreated;
    }

    if(dateModified != null){
      data['dateModified'] = dateModified;
    }

    if(dateFinished != null){
      data['dateFinished'] = dateFinished;
    }

    data['status'] = status;
    return data;
  }

}

class Tag{
  String? tagId;
  String tagName = "";
  String? taskId;

  Tag({this.tagId, required this.tagName, this.taskId});

  Tag.fromJson(Map<String, dynamic> data) {
    if(data['tagId'] != null){
      tagId = data['tagId'];
    }
    tagName = data["tagName"];
    if(data['taskId'] != null){
      taskId = data["taskId"];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(tagId != null){
      data['tagId'] = tagId;
    }
    data['tagName'] = tagName;
    if(taskId != null){
      data['taskId'] = taskId;
    }
    return data;
  }
}