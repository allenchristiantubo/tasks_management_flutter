import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/task_model.dart';
import '../shared/menu_bottom.dart';
import '../data/repository/API/tasks_repository.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.task});

  final Task task;
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  List<Tag> tags = [];
  int tagsCount = 0;
  final _statusItems = ['New', 'In Progress', 'Completed'];
  String statusValue = "";
  bool _validateTitle = false;
  bool _validateDescription = false;
  TasksRepository api = TasksRepository();

  @override
  // TODO: implement widget
  EditTaskScreen get widget => super.widget;

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item, style: const TextStyle(fontFamily: "Poppins"))
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Task task = widget.task;
    _titleController.text = task.taskName;
    _descriptionController.text = task.taskDescription;
    statusValue = (task.status == 0 ? 'New' : task.status == 1 ? 'In Progress' : 'Completed');
    _validateTitle = true;
    _validateDescription = true;
    for(var tag in task.tag!){
      tags.add(tag);
    }
    tagsCount = tags.length;
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _titleController.dispose();
  //   _descriptionController.dispose();
  //   _tagsController.dispose();
  //   super.dispose();
  // }

  updateTask(String taskId, String taskName, String taskDescription, int status, List<Tag> tags) async{
    Task taskToUpdate = Task(taskId: taskId, taskName: taskName, taskDescription: taskDescription, status: status, tag: tags);
    Task returnedTask = await api.updateTask(taskToUpdate);
  }

  @override
  Widget build(BuildContext context) {
    Task task = widget.task;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tasks Manager', style: TextStyle(fontFamily: "Poppins")),
            actions: ( _validateTitle == true && _validateDescription ? [
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      String taskName = _titleController.text;
                      String taskDescription = _descriptionController.text;
                      int status = (statusValue == 'New' ? 0 : statusValue == 'In Progress' ? 1 : 2);
                      updateTask(task.taskId.toString(), taskName, taskDescription, status, tags);
                      Navigator.pop(context, "Task updated successfully.");
                    },
                    child: const Icon(Icons.check, size: 28.0,),
                  )
              ),
            ] : const []
            )
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          controller: _titleController,
                          autofocus: true,
                          maxLines: null,
                          cursorColor: Colors.deepPurple,
                          decoration: const InputDecoration(
                            hintText: 'Title',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500),
                          ),
                          textInputAction: TextInputAction.done,
                          onChanged: (value){
                            setState((){
                              if(value.isNotEmpty){
                                _validateTitle = true;
                              }else{
                                _validateTitle = false;
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 200,
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child:  TextField(
                          controller: _descriptionController,
                          cursorColor: Colors.deepPurple,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            hintText: 'Description',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500),
                          ),
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value){
                            setState((){
                              if(value.isNotEmpty){
                                _validateDescription = true;
                              }else{
                                _validateDescription = false;
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          cursorColor: Colors.deepPurple,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            hintText: 'New tag...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w500),
                          ),
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          controller: _tagsController,
                          onSubmitted: (value){
                            var isExisting = tags.where((tag) => tag.tagName == value);
                            if(isExisting.isEmpty){
                              setState((){
                                Tag newTag = Tag(tagName: value);
                                tags.add(newTag);
                                tagsCount = tags.length;
                                _tagsController.text = '';
                              });
                            }
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: (tagsCount == 0 ? 50 : 0)),
                        alignment: Alignment.centerLeft,
                        child: Text('Tags entered : $tagsCount',
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        color: Colors.white,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Wrap(
                            verticalDirection: VerticalDirection.down,
                            children: [
                              for(var tag in tags)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: InputChip(
                                    backgroundColor: const Color.fromRGBO(224, 234, 243, 1),
                                    deleteIconColor: Colors.deepPurple,
                                    label: Text(tag.tagName),
                                    onDeleted: (){
                                      setState((){
                                        tags.remove(tag);
                                        tagsCount = tags.length;
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: DropdownButtonFormField(
                          items: _statusItems.map(buildMenuItem).toList(),
                          value: (widget.task.status == 0 ? 'New' : widget.task.status == 1 ? 'In Progress' : 'Completed'),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.deepPurple),
                          onChanged: (value) => setState(() => statusValue = value as String),
                        ),
                      )
                    ],
                  )
              )
            ],
          )
        ),
    );
  }
}
