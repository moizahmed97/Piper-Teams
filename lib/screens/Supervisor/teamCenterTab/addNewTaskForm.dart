import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/services/database.dart';

class AddNewTask extends StatefulWidget {
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
  );

  final _formKey = GlobalKey<FormState>();
  final List<String> taskTypes = ['Critical', 'Normal', 'Low'];

  // form values
  String _task;
  String _taskType;

  @override
  Widget build(BuildContext context) {
    // Get the member ID from the widget tree using Provider
    final memberID = Provider.of<String>(context);

    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Add Next Task',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              items: taskTypes.map((taskType) {
                return DropdownMenuItem(
                  value: taskType,
                  child: Text('$taskType'),
                );
              }).toList(),
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Select Priority',
                contentPadding: EdgeInsets.symmetric(vertical: 9),
              ),
              value: _taskType ?? 'Normal',
              onChanged: (value) {
                setState(() {
                  _taskType = value;
                });
              },
              isExpanded: true,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: "",
              decoration: textInputDecoration.copyWith(hintText: "New Task"),
              validator: (val) => val.isEmpty ? 'Please enter the task' : null,
              onChanged: (val) => setState(() => _task = val),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                color: Colors.teal[400],
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var currentDateTime = DateTime.now();
                  DatabaseService().createNewTask(
                      memberID,
                      Task(
                          task: _task ?? " ",
                          taskType: _getTaskTypeInt(_taskType),
                          taskID: "Incomplete",
                          feedback: "",
                          status: false,
                          deadline: currentDateTime.add(Duration(hours: 24)),
                          dateCreated: currentDateTime));
                  Navigator.of(context).pop();
                }),
          ],
        ));
  }

  int _getTaskTypeInt(String val) {
    if (val == 'Critical') {
      return 1;
    } else if (val == 'Normal') {
      return 2;
    } else {
      return 3;
    }
  }
}
