import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _statusItems = ['New', 'In Progress', 'Completed'];
  String? value;

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item, style: const TextStyle(fontFamily: "Poppins"))
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tasks Manager', style: TextStyle(fontFamily: "Poppins")),
          automaticallyImplyLeading: false
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Task Description',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: DropdownButtonFormField(items: _statusItems.map(buildMenuItem).toList(),
                    onChanged: (value) => setState(() => this.value = value as String?),
                    value: value,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(224, 234, 243, 1),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel', style: TextStyle(fontFamily: "Poppins", color: Colors.deepPurple))
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            primary:Colors.deepPurple,
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('Save', style: TextStyle(fontFamily: "Poppins", color: Colors.white))
                      ),
                    )
                  ],
                )
              ],
            )
          ),
        ),

    );
  }
}
