import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/widgets/loading.dart';

class AddUpdateTask extends StatefulWidget {
  @override
  _AddUpdateTaskState createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
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
    return StreamBuilder<List<Task>>(
        // Get the stream from the latest Collection, gives us task Objects from the documents in the Collection
        stream: DatabaseService().getLatestTask(memberID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Task> latestTasks = snapshot.data;
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
                      height: 30,
                    ),
                    TextFormField(
                      initialValue: latestTasks[0].task,
                      keyboardType: TextInputType.number,
                      decoration: textInputDecoration,
                      validator: (val) =>
                          val.isEmpty ? 'Please enter the task' : null,
                      onChanged: (val) => setState(() => _task = val),
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
                    RaisedButton(
                        color: Colors.teal[400],
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          var currentDateTime = DateTime.now();
                          DatabaseService().updateLatestTask(
                              memberID,
                              Task(
                                  task: _task ??
                                      snapshot.data[0].task ??
                                      " ",
                                  taskType: _getTaskTypeInt(_taskType),
                                  grade: "Incomplete",
                                  feedback: "None",
                                  status: false,
                                  deadline: currentDateTime,
                                  dateCreated: currentDateTime));
                          Navigator.of(context).pop();
                        }),
                  ],
                ));
          } else {
            return Loading();
          }
        });
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
