import 'package:flutter/material.dart';
import 'package:tasks_management/screens/search_screen.dart';
import 'package:tasks_management/shared/dashboard_cards.dart';
import 'package:tasks_management/shared/menu_bottom.dart';
import '../model/task_model.dart';
import '../data/repository/API/tasks_repository.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Task>? tasks;
  List<Task> newTasks = [];
  var isLoaded = false;

  @override
  void initState(){
    super.initState();
    getAllTasks();
  }

  getAllTasks() async {
    //API
    tasks = await TasksRepository().getAllTasks();
    if(tasks?.isNotEmpty ?? false){
      setState((){
        isLoaded = true;
        newTasks = tasks!.where((task) => task.status == 0).toList();
      });
    }else{
      setState((){
        isLoaded = false;
      });
    }
  }

  // @override
  // void dispose(){
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
        ),
        body: Visibility(
            visible: isLoaded,
            replacement: const Center(
                child: CircularProgressIndicator(
                color: Colors.deepPurple,
              )
            ),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Container(
                              margin:const EdgeInsets.only(bottom: 10),
                              child:const Center(child:Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, fontFamily: "Poppins", color: Colors.black)))
                          ),
                          SizedBox(
                            child: DashboardCards(tasks:tasks),
                          ),
                          Container(
                              margin:const EdgeInsets.only(left: 10, right: 10, top:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('New Tasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Poppins", color: Colors.black)),
                                  TextButton(onPressed: (){
                                    //Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuBottom(1)));
                                  }, child: const Text('View All Tasks', style: TextStyle(fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.bold)))
                                ],
                              )
                          ),
                          SizedBox(
                            child: (newTasks.isNotEmpty ?
                              ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: newTasks.length,
                              itemBuilder: (BuildContext context, int index){
                                return Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(224, 234, 243, 1)
                                      ),
                                      child: ListTile(
                                        title: Text(newTasks[index].taskName, style: const TextStyle(color: Colors.deepPurple)),
                                        trailing: const Icon(Icons.new_releases_outlined, color: Colors.deepPurple),
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                );
                              }
                              ) : const Center(child: Text('No new tasks found.', style: TextStyle(fontFamily: "Poppins", fontSize: 14))))
                          )
                        ]
                    ),
                  ),
                ),
              ],
            ),
        )
      ),
    );
  }
}
