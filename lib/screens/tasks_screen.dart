import 'package:flutter/material.dart';
import 'package:tasks_management/screens/tasks_edit_screen.dart';
import 'package:tasks_management/main.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  //List<String> tasks = ['Research about flutter', 'Create a dashboard for task manager', 'Connect to Web API', 'New Task', 'Edited Task', 'Completed Task'];
  //List<int> status = [1,1,2,0,0,2];
  List<Task> tasks = [
    Task("1", "Research about flutter",  "Read flutter documentation",  1, DateTime.parse('2022-06-20')),
    Task("2", "Create a dashboard", "Design a dashboard for task manager", 1, DateTime.parse('2022-06-21')),
    Task("3", "Connect to Web API",  "Connect application to web API", 2, DateTime.parse('2022-06-20')),
    Task( "4",  "Learn Dart language", "Start learning dart",  0, DateTime.parse('2022-06-23')),
    Task( "5",  "Find widgets in pub.dev",  "Find useful widgets",  0, DateTime.parse('2022-06-22')),
    Task( "6",  "Connect screens of task manager",  "Connect all screens",  2, DateTime.parse('2022-06-22'))
  ];

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      return Colors.deepPurple;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks Manager', style: TextStyle(fontFamily: "Poppins")),
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                  margin:const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: const [
                      Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Poppins", color: Colors.black)),
                      Expanded(
                          child:Padding(
                            padding: EdgeInsets.only(left:30, right: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search tasks',
                                suffixIcon: Icon(Icons.search)
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                          )
                      ),
                    ],
                  )
              ),
              SizedBox(
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index){
                        return Dismissible(
                          key: ValueKey<String>(tasks[index].taskId),
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmation"),
                                  content: const Text("Are you sure to delete this task?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Cancel", style: TextStyle(color: Colors.deepPurple)),
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          setState(() {
                                            tasks.removeAt(index);
                                          });
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text("Delete", style: TextStyle(color: Colors.deepPurple))
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top:10),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditTaskScreen(task:tasks[index])),
                                    );
                                  },
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical:20, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(tasks[index].taskName,overflow: TextOverflow.ellipsis,maxLines: 1, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, fontFamily: "Poppins")),
                                                  Text(DateFormat('MMMM dd, yyyy').format(tasks[index].dateCreated), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, fontFamily: "Poppins"))
                                                ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: (tasks[index].status == 0 ? const Color.fromRGBO(224, 234, 243, 1) : tasks[index].status == 1 ? const Color.fromRGBO(159, 131, 207, 1) : const Color.fromRGBO(123, 78, 203, 1)),
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: Text(tasks[index].status == 0 ? 'New': tasks[index].status == 1 ? 'In Progress' : 'Completed',
                                      style: TextStyle(fontFamily: "Poppins", fontSize: 11, fontWeight: FontWeight.w900, color: (tasks[index].status == 0 ? Colors.deepPurple : Colors.white)),
                                    )
                                  ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>  Container(margin: const EdgeInsets.symmetric(vertical: 5)),
                      itemCount: tasks.length)
              ),
            ],
          ),
        ),
      ),
    );
  }
}