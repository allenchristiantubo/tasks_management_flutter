import 'package:flutter/material.dart';
import '../data/repository/API/tasks_repository.dart';
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

  TasksRepository api = TasksRepository();

  //Insert into Web API
  //After inserting into API, will return the task created
  //pass it to store on local storage
  createTask(String taskName, String taskDescription, List<Tag> tags) async{
    Task newTask = Task(taskName: taskName, taskDescription: taskDescription, tag: tags, status: 0);
    Task taskCreated = await api.createTask(newTask);
    //var result = await TaskRepository().create(taskCreated);
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
                  onTap: () {
                    var taskName = _titleController.text;
                    var taskDescription = _descriptionController.text;
                    createTask(taskName, taskDescription, tags);
                    final snackBar = SnackBar(
                      content: const Text('Task created successfully.'),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          // Some code to undo the change.
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuBottom(0)));
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
