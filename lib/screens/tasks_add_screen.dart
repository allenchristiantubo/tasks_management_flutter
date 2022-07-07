import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_management/data/services/database_helper.dart';
import 'package:tasks_management/utils/validator.dart';
import '../data/repository/API/api_tasks_repository.dart';
import '../data/repository/local/local_tasks_repository.dart';
import '../model/task_model.dart';
import '../shared/menu_bottom.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Tag> tags = [];
  int tagsCount = 0;
  bool _showAddTag = false;
  bool _validateTitle = false;
  bool _validateDescription = false;

  late Database _database;
  APITasksRepository api = APITasksRepository();
  late LocalTasksRepository local;

  //Insert into Web API
  //After inserting into API, will return the task created
  //pass it to store on local storage
  Future<Task?> createTask(String taskName, String taskDescription, List<Tag> tags) async{
    _database = await DatabaseHelper.getInstance();
    local = LocalTasksRepository(_database);
    Task newTask = Task(taskName: taskName, taskDescription: taskDescription, tag: tags, status: 0);
    Task? taskCreated = await api.createTask(newTask);
    if(taskCreated != null){
      var result = await local.create(taskCreated);
      if(result != null){
        return taskCreated;
      }
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New task', style: TextStyle(fontFamily: "Poppins")),
          actions: ( _validateTitle == true && _validateDescription ? [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    var taskName = _titleController.text;
                    var taskDescription = _descriptionController.text;
                    Task? returnedTask = await createTask(taskName, taskDescription, tags);
                    if(returnedTask != null){
                      if(!mounted) return;
                      Navigator.pop(context, returnedTask);
                    }
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
                            value.isEmpty ? _validateTitle = false : _validateTitle = true;
                          });
                        },
                        onSubmitted: (value){
                          setState((){
                            var result = TaskValidator().validateTaskName(value);
                            if(result != null){
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(content: Text(result)));
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
                            value.isEmpty ? _validateDescription = false : _validateDescription = true;
                          });
                        },
                        onSubmitted: (value){
                          setState((){
                            var result = TaskValidator().validateTaskDescription(value);
                            if(result != null){
                              ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(SnackBar(content: Text(result)));
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child:
                        TextButton.icon(
                            icon: (_showAddTag == true ? const Icon(Icons.remove) : const Icon(Icons.add)),
                            onPressed: (){
                              setState((){
                                if(_showAddTag == false){
                                  _showAddTag = true;
                                }else{
                                  _showAddTag = false;
                                }
                              });
                            },
                            label: Text(_showAddTag == true ? 'Hide Tags' : 'Add Tags')
                        ),
                    ),
                    (_showAddTag == true ?
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
                            setState((){
                              bool isExisting = tags.any((tag) => tag.tagName.toLowerCase().contains(value.toLowerCase()));
                              if(!isExisting){
                                tags.add(Tag(tagName: value));
                                tagsCount = tags.length;
                              }
                            });
                            _tagsController.text = '';
                          },
                        ),
                      ) : const SizedBox.shrink()
                    ),
                    (_showAddTag == true ?
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
                    ) : const SizedBox.shrink()
                    ),
                    (_showAddTag == true ?
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
                      ) : Container(height: 100, color : (_showAddTag == true ? Colors.white : Colors.white10))
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
