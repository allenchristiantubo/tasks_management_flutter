import 'package:flutter/material.dart';

enum Menu{showCompletedTasks, hideCompletedTasks}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isShowCompletedTask = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: TextField(
            autofocus: true,
            cursorColor: Colors.white,
            onSubmitted: (value){
              debugPrint(value);
            },
            style: const TextStyle(color: Colors.white, fontFamily: "Poppins"),
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white, fontFamily: "Poppins")),
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: PopupMenuButton<Menu>(
                icon: const Icon(Icons.more_horiz),
                onSelected: (Menu item){
                  setState((){
                    if(item.name == "showCompletedTasks"){
                      _isShowCompletedTask = true;
                    }else{
                      _isShowCompletedTask = false;
                    }
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  PopupMenuItem<Menu>(
                      value: (_isShowCompletedTask == false ? Menu.showCompletedTasks : Menu.hideCompletedTasks),
                      child: (_isShowCompletedTask == false ? const Text('Show completed tasks') : const Text('Hide completed tasks'))
                    )
                ],
              )

          ),
        ],
      ),
      body: Center(
        child: Text('Search Task'),
      ),
    );
  }
}
