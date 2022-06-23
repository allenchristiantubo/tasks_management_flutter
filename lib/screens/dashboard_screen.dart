import 'package:flutter/material.dart';
import 'package:tasks_management/screens/tasks_edit_screen.dart';
import 'package:tasks_management/screens/tasks_screen.dart';
import 'package:tasks_management/shared/menu_bottom.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks Manager', style: TextStyle(fontFamily: "Poppins")),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  height: 64,
                  margin: const EdgeInsets.only(top:10, bottom: 15),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage('https://scontent.fmnl17-3.fna.fbcdn.net/v/t1.6435-9/29062567_2240674839279747_4346929446729547776_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeF8WdsHmVqTNMNNmVx0Xsnnfc17Nz1e07l9zXs3PV7TubON2V3-KuPJnBfmItp2LhzsvNSMaPwNzd5tE6qZMuJq&_nc_ohc=0V0CoDuYossAX_bzue1&_nc_ht=scontent.fmnl17-3.fna&oh=00_AT-m2ZKGzaQTjj0yF5GGAByT15d0AzJoaij8GUJADbEKHw&oe=62D7B4D2'),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Allen Christian Tubo', style: TextStyle(fontFamily: "Poppins", color: Colors.black)),
                          Text('/allentubo09', style: TextStyle(fontFamily: "Poppins", color:Colors.black)),
                        ],
                      ),
                    ],
                  )
                ),
                Container(
                  margin:const EdgeInsets.only(bottom: 20),
                  child:const Center(child:Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, fontFamily: "Poppins", color: Colors.black),),)
                ),
                SizedBox(
                   child: GridView.count(
                      shrinkWrap: true,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      primary: false,
                      crossAxisCount: 2,
                      children: [
                        Card(
                          color: const Color.fromRGBO(240,245,250, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.task_outlined, color: Colors.deepPurple,),
                                  Padding(
                                    padding: EdgeInsets.only(left:10),
                                    child: Text('33', style: TextStyle(fontSize:20, color: Colors.deepPurple)),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Assigned Tasks', style: TextStyle(fontSize:14, color: Colors.deepPurple)),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: const Color.fromRGBO(224, 234, 243, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.new_releases_outlined, color: Colors.deepPurple,),
                                  Padding(
                                    padding: EdgeInsets.only(left:10),
                                    child: Text('33', style: TextStyle(fontSize:20, color: Colors.deepPurple)),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('New Tasks', style: TextStyle(fontSize:14, color: Colors.deepPurple)),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: const Color.fromRGBO(159, 131, 207, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.timer_outlined, color: Colors.white,),
                                  Padding(
                                    padding: EdgeInsets.only(left:10),
                                    child: Text('33', style: TextStyle(fontSize:20, color: Colors.white)),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('In Progress Tasks', style: TextStyle(fontSize:14, color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: const Color.fromRGBO(123, 78, 203, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.check_circle_outlined, color: Colors.white),
                                  Padding(
                                    padding: EdgeInsets.only(left:10),
                                    child: Text('33', style: TextStyle(fontSize:20, color: Colors.white)),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Completed Tasks', style: TextStyle(fontSize:14, color: Colors.white)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                ),
              ]
              ),
          ),
      )
    );
  }
}
