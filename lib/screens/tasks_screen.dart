import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tasks_management/data/repository/local/tasks_repository.dart';
import 'package:tasks_management/screens/search_screen.dart';
import 'package:tasks_management/screens/tasks_edit_screen.dart';
import 'package:tasks_management/shared/menu_bottom.dart';
import '../model/task_model.dart';
import '../data/repository/API/tasks_repository.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showCompleted = false;
  bool _showInProgress = false;
  bool _showNew = false;
  Icon _iconShowCompleted = const Icon(Icons.keyboard_arrow_right);
  Icon _iconShowNew = const Icon(Icons.keyboard_arrow_right);
  Icon _iconShowInProgress = const Icon(Icons.keyboard_arrow_right);
  bool isLoaded = false;
  List<Task>? tasks = [];
  List<Task> newTasks = [];
  List<Task> inProgressTasks = [];
  List<Task> finishedTasks = [];
  bool isInProgressTasksEmpty = true;
  bool isNewTasksEmpty = true;
  late MenuBottom menuBottom;

  @override
  void initState(){
    super.initState();
    getAllTasks();
  }

  Future getAllTasks() async {
    //API
    tasks = await TasksRepository().getAllTasks();
    if (tasks != null) {
      setState(() {
        isLoaded = true;
        newTasks = tasks!.where((task) => task.status == 0).toList();
        inProgressTasks = tasks!.where((task) => task.status == 1).toList();
        finishedTasks = tasks!.where((task) => task.status == 2).toList();
      });
    }
  }

  getNewTasksCount(){
    if(newTasks.isNotEmpty){
      return newTasks.length;
    }else{
      return 0;
    }
  }

  getInProgressTasksCount(){
    if(inProgressTasks.isNotEmpty){
      return inProgressTasks.length;
    }else{
      return 0;
    }
  }

  getFinishedTasksCount(){
    if(finishedTasks.isNotEmpty){
      return finishedTasks.length;
    }else{
      return 0;
    }
  }

  Future deleteTask(String id) async {
    bool deleted = await TasksRepository().deleteTask(id);
    if(deleted){
      getAllTasks();
    }
    //await TaskRepository().delete(id);

  }

  Future updateStatus(String taskId, int status) async {
   Task? task = await TasksRepository().updateStatus(taskId, status);
   if(task != null){
     getAllTasks();
   }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tasks Manager', style: TextStyle(fontFamily: "Poppins")),
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
                    },
                    child: const Icon(Icons.search, size: 28.0,),
                  )
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.list_outlined),
                ),
                Tab(
                  icon: Icon(Icons.new_releases_outlined),
                ),
                Tab(
                  icon: Icon(Icons.timer_outlined),
                ),
                Tab(
                    icon: Icon(Icons.checklist_outlined)
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          SizedBox(
                            child: Column(
                              children: [
                                TextButton.icon(
                                  onPressed: (){
                                    setState((){
                                      if(_showInProgress == true){
                                        _showInProgress = false;
                                        _iconShowInProgress = const Icon(Icons.keyboard_arrow_right);
                                      }else{
                                        _showInProgress = true;
                                        _iconShowInProgress = const Icon(Icons.keyboard_arrow_down);
                                      }
                                    });
                                  },
                                  icon: _iconShowInProgress,
                                  label: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('(${getInProgressTasksCount()}) In Progress')
                                  )
                                ),
                                SizedBox(
                                  child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: getInProgressTasksCount(),
                                      itemBuilder: (BuildContext context, int index){
                                        if(inProgressTasks.isNotEmpty && _showInProgress){
                                          final Task task = inProgressTasks[index];
                                          return Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(159, 131, 207, 1)
                                                ),
                                                child: Slidable(
                                                    startActionPane: ActionPane(
                                                      motion: const BehindMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (_){
                                                            updateStatus(task.taskId!, 0);
                                                          },
                                                          backgroundColor: const Color.fromRGBO(224, 234, 243, 1),
                                                          foregroundColor: Colors.deepPurple,
                                                          icon: Icons.new_releases_outlined,
                                                          label: 'Mark as New',
                                                        )
                                                      ],
                                                    ),
                                                    endActionPane: ActionPane(
                                                      motion: const BehindMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (_) => showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) => AlertDialog(
                                                              title: const Text('Confirmation!'),
                                                              content: const Text('Are you sure to delete this task permanently?'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: (){
                                                                    deleteTask(task.taskId!);
                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: const Text('Yes'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () => Navigator.pop(context),
                                                                  child: const Text('No'),
                                                                )
                                                              ],
                                                            )
                                                          ),
                                                          backgroundColor: const Color.fromRGBO(248, 89, 124, 1),
                                                          foregroundColor: Colors.white,
                                                          icon: Icons.delete_outline,
                                                          label: 'Delete',
                                                        )
                                                      ],
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        String? result = await Navigator.push(context,  MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)));
                                                        if(result != null){
                                                          getAllTasks();
                                                          ScaffoldMessenger.of(context)
                                                            ..removeCurrentSnackBar()
                                                            ..showSnackBar(SnackBar(content: Text(result)));
                                                        }
                                                      },
                                                      child: ListTile(
                                                        leading: IconButton(
                                                            iconSize: 28,
                                                            onPressed: () {
                                                              updateStatus(task.taskId!, 2);
                                                            },
                                                            icon: const Icon(Icons.check_circle_outlined, color: Colors.white),
                                                            tooltip: 'Mark as completed'
                                                        ),
                                                        title: Text(task.taskName, style: const TextStyle(color: Colors.white)),
                                                        subtitle: Text("Modified: ${DateFormat.yMMMMd().format(DateTime.parse(task.dateModified.toString()))}", style: const TextStyle(color: Colors.white60)),
                                                      ),
                                                    ),
                                                ),
                                              ),
                                              const Divider()
                                            ],
                                          );
                                        }else{
                                          return const SizedBox.shrink();
                                        }
                                      }
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              children: [
                                TextButton.icon(
                                  onPressed: (){
                                    setState((){
                                      if(_showNew == true){
                                        _showNew = false;
                                        _iconShowNew = const Icon(Icons.keyboard_arrow_right);
                                      }else{
                                        _showNew = true;
                                        _iconShowNew = const Icon(Icons.keyboard_arrow_down);
                                      }
                                    });
                                  },
                                  icon: _iconShowNew,
                                  label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('(${getNewTasksCount()}) New')
                                  )
                                ),
                                SizedBox(
                                  child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: getNewTasksCount(),
                                      itemBuilder: (BuildContext context, int index){
                                        if(newTasks.isNotEmpty && _showNew){
                                          final Task task = newTasks[index];
                                          return Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(224, 234, 243, 1)
                                                ),
                                                child: Slidable(
                                                  startActionPane: ActionPane(
                                                    motion: const BehindMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        onPressed: (_){
                                                          updateStatus(task.taskId!, 1);
                                                        },
                                                        backgroundColor: const Color.fromRGBO(159, 131, 207, 1),
                                                        foregroundColor: Colors.white,
                                                        icon: Icons.timer_outlined,
                                                        label: 'Mark as In Progress',
                                                      )
                                                    ],
                                                  ),
                                                  endActionPane: ActionPane(
                                                    motion: const BehindMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        onPressed: (_) => showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) => AlertDialog(
                                                            title: const Text('Confirmation!'),
                                                            content: const Text('Are you sure to delete this task permanently?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: (){
                                                                  deleteTask(task.taskId!);
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text('Yes'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () => Navigator.pop(context),
                                                                child: const Text('No'),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        backgroundColor: const Color.fromRGBO(248, 89, 124, 1),
                                                        foregroundColor: Colors.white,
                                                        icon: Icons.delete_outline,
                                                        label: 'Delete',
                                                      )
                                                    ],
                                                  ),
                                                  child: GestureDetector(
                                                    child: ListTile(
                                                      leading: IconButton(
                                                          iconSize: 28,
                                                          onPressed: () {
                                                            updateStatus(task.taskId!, 2);
                                                          },
                                                          icon: const Icon(Icons.check_circle_outlined, color: Colors.deepPurple),
                                                          tooltip: 'Mark as completed'
                                                      ),
                                                      title: Text(task.taskName, style: const TextStyle(color: Colors.deepPurple)),
                                                      subtitle: Text("Created: ${DateFormat.yMMMMd().format(DateTime.parse(task.dateCreated.toString()))}", style: const TextStyle(color: Colors.deepPurple)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Divider()
                                            ],
                                          );
                                        }else{
                                          return const SizedBox.shrink();
                                        }
                                      }
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Column(
                              children: [
                                  TextButton.icon(
                                    onPressed: (){
                                      setState((){
                                        if(_showCompleted == true){
                                          _showCompleted = false;
                                          _iconShowCompleted = const Icon(Icons.keyboard_arrow_right);
                                        }else{
                                          _showCompleted = true;
                                          _iconShowCompleted = const Icon(Icons.keyboard_arrow_down);
                                        }
                                      });
                                    },
                                    label: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('(${getFinishedTasksCount()}) Completed')
                                    ),
                                    icon: _iconShowCompleted,
                                ),
                                SizedBox(
                                  child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: getFinishedTasksCount(),
                                      itemBuilder: (BuildContext context, int index){
                                        if(finishedTasks.isNotEmpty && _showCompleted){
                                          final Task task = finishedTasks[index];
                                          return Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(123, 78, 203, 1)
                                                ),
                                                child: Slidable(
                                                    child: GestureDetector(
                                                      child: ListTile(
                                                        leading: IconButton(
                                                          iconSize: 28,
                                                          onPressed: () {
                                                          updateStatus(task.taskId!, 1);
                                                          },
                                                          icon: const Icon(Icons.check_circle, color: Colors.white),
                                                          tooltip: 'Mark as in progress'
                                                        ),
                                                        title: Text(task.taskName, style: const TextStyle(color: Colors.white,decoration: TextDecoration.lineThrough)),
                                                        subtitle: Text("Completed: ${task.dateFinished}", style: const TextStyle(color: Colors.white60)),
                                                      ),
                                                    )
                                                ),
                                              ),
                                              const Divider()
                                            ],
                                          );
                                        }else{
                                          return const SizedBox.shrink();
                                        }
                                      }
                                  ),
                                ),
                              ]
                            ),
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Visibility(child: SizedBox()),
              const Visibility(child: SizedBox()),
              const Visibility(child: SizedBox())
          ]
          ),
          ),
      ),
    );
  }

  Widget buildListTile(Task task) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    title: Text(task.taskName, style: const TextStyle(fontSize: 18, fontFamily: "Poppins")),
  );
}