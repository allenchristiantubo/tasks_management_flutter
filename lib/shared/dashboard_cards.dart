import 'package:flutter/material.dart';

import '../model/task_model.dart';

class DashboardCards extends StatelessWidget {
  const DashboardCards({Key? key, this.tasks}) : super(key: key);
  final Color _bgCardTotal = const Color.fromRGBO(240, 245, 250, 1);
  final Color _bgCardNew = const Color.fromRGBO(224, 234, 243, 1);
  final Color _bgCardInProgress = const Color.fromRGBO(159, 131, 207, 1);
  final Color _bgCardCompleted = const Color.fromRGBO(123, 78, 203, 1);
  final List<Task>? tasks;

  getTasksCount(){
    if(tasks != null){
      return tasks!.length.toString();
    }else{
      return 0.toString();
    }
  }

  getTasksCountPerStatus(int status){
    if(tasks != null){
      return tasks!.where((task) => task.status == status).length.toString();
    }else{
      return 0.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        key: key,
        shrinkWrap: true,
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index){
          return Card(
            color: (index == 0 ? _bgCardTotal : index == 1 ? _bgCardNew : index == 2 ? _bgCardInProgress : _bgCardCompleted),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon((index == 0 ? Icons.task_outlined : index == 1 ? Icons.new_releases_outlined : index == 2 ? Icons.timer_outlined : Icons.checklist_outlined),
                        color: (index == 0 || index == 1 ? Colors.deepPurple : Colors.white)),
                    Padding(
                      padding: const EdgeInsets.only(left:10),
                      child: Text((index == 0 ? getTasksCount() : getTasksCountPerStatus(index - 1)), style: TextStyle(fontSize:20, color: (index == 0 || index == 1 ? Colors.deepPurple : Colors.white))),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text((index == 0 ? 'Assigned Tasks' : index == 1 ? 'New Tasks' : index == 2 ? 'In Progress Tasks' : 'Completed Tasks'),
                    style: TextStyle(fontSize:14, color: (index == 0 || index == 1 ? Colors.deepPurple : Colors.white)),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}

