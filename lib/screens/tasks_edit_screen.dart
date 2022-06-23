import 'package:flutter/material.dart';
import 'package:tasks_management/main.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.task});

  final Task task;
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  final _statusItems = ['New', 'In Progress', 'Completed'];
  String? value;

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(item, style: const TextStyle(fontFamily: "Poppins"))
  );

  @override
  // TODO: implement widget
  EditTaskScreen get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.taskName;
    _taskDescriptionController.text = widget.task.taskDescription;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Date Created: ${DateFormat('MMMM dd, yyyy').format(widget.task.dateCreated)}')
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextField(
                      controller: _taskNameController,
                      decoration: const InputDecoration(
                        labelText: 'Task Name',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextField(
                      controller: _taskDescriptionController,
                      decoration: const InputDecoration(
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
                      value: (widget.task.status == 0 ? 'New' : widget.task.status == 1 ? 'In Progress' : 'Completed'),
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
