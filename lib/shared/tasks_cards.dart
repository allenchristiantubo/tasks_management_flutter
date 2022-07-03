import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasks_management/screens/tasks_edit_screen.dart';
import '../model/task_model.dart';

class TasksCards extends StatefulWidget {
  const TasksCards({super.key, required this.task});

  final Task task;
  @override
  State<TasksCards> createState() => _TasksCardsState();
}

class _TasksCardsState extends State<TasksCards> {
  bool isLoaded = false;

  @override
  // TODO: implement widget
  TasksCards get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskScreen(task:widget.task)));
        },
        child: Card(
          color: (widget.task.status == 0 ? const Color.fromRGBO(224, 234, 243, 1) : widget.task.status == 1 ? const Color.fromRGBO(159, 131, 207, 1) : const Color.fromRGBO(123, 78, 203, 1)),
          elevation: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(widget.task.taskName,overflow: TextOverflow.ellipsis,maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    color: (widget.task.status == 0 ? Colors.deepPurple : Colors.white),
                                    decoration: (widget.task.status == 2 ? TextDecoration.lineThrough : TextDecoration.none)
                                )
                            ),
                            (widget.task.status == 0 || widget.task.status == 1 ?
                              Text('Created: ${DateFormat('MMMM dd, yyyy').format(widget.task.dateCreated as DateTime)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      fontFamily: "Poppins",
                                      color: (widget.task.status == 0 ? Colors.deepPurple[700] : Colors.white70)
                                  )
                              )
                            :
                              Text('Completed: ${DateFormat('MMMM dd, yyyy').format(widget.task.dateFinished as DateTime)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  color: Colors.white70,
                                ),
                              )
                            )
                          ],
                        ),
                        const Spacer()
                        ,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon((widget.task.status == 0 ? Icons.new_releases_outlined : widget.task.status == 1 ? Icons.timer_outlined : Icons.checklist_outlined),
                                color: (widget.task.status == 0 ? Colors.deepPurple : Colors.white)
                            ),
                            Text((widget.task.status == 0 ? 'New' : widget.task.status == 1 ? 'In Progress' : 'Completed'),
                              style: TextStyle(color: (widget.task.status == 0 ? Colors.deepPurple : Colors.white)),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
    );
  }
}
