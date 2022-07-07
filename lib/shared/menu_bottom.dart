import 'package:flutter/material.dart';
import 'package:tasks_management/screens/dashboard_screen.dart';
import 'package:tasks_management/screens/tasks_add_screen.dart';
import 'package:tasks_management/screens/tasks_screen.dart';

class MenuBottom extends StatefulWidget {
  MenuBottom(this.selectedIndex, {Key? key}) : super(key: key);
  int selectedIndex = 0;
  @override
  State<MenuBottom> createState() => _MenuBottomState();
}

class _MenuBottomState extends State<MenuBottom> {
  @override
  // TODO: implement widget
  MenuBottom get widget => super.widget;
  Color _dashboardColor = Colors.white;
  Color _tasksColor = Colors.grey;
  static const List<Widget> _children = [
    DashboardScreen(),
    TasksScreen(),
    AddTaskScreen()
  ];

  void onTapped(int index){
    setState((){
      widget.selectedIndex = index;
      if(index == 0){
        _dashboardColor = Colors.white;
        _tasksColor = Colors.grey;
      }else if(index == 1){
        _dashboardColor = Colors.grey;
        _tasksColor = Colors.white;
      }else{
        _dashboardColor = Colors.grey;
        _tasksColor = Colors.grey;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:_children[widget.selectedIndex],
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.deepPurple,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  tooltip: 'Dashboard',
                  icon: Icon(Icons.dashboard, color: _dashboardColor),
                  onPressed: () {
                    onTapped(0);
                  },
                ),
                IconButton(
                  tooltip: 'Tasks',
                  icon: Icon(Icons.task, color: _tasksColor),
                  onPressed: () {
                    onTapped(1);
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
}
