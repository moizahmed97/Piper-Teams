import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';

class UpdateTask extends StatefulWidget {
  @override
  _UpdateTaskState createState() => _UpdateTaskState();
  final String taskID;

  UpdateTask({this.taskID});
}

class _UpdateTaskState extends State<UpdateTask> {
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
    return StreamBuilder<Task>(
        // Get the stream from the latest Collection, gives us task Objects from the documents in the Collection
        stream: DatabaseService().getTask(memberID, widget.taskID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Task task = snapshot.data;
            return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Update Task',
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
                      value: _taskType ??
                          _getTaskTypeString(task.taskType) ??
                          'Normal',
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
                      initialValue: task.task,
                      decoration:
                          textInputDecoration.copyWith(hintText: "New Task"),
                      validator: (val) =>
                          val.isEmpty ? 'Please enter the task' : null,
                      onChanged: (val) => setState(() => _task = val),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton.icon(
                            icon: Icon(
                              Icons.update,
                              color: Colors.white,
                            ),
                            color: Colors.teal[400],
                            label: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              var currentDateTime = DateTime.now();

                              DatabaseService().updateExisitngTask(
                                  memberID,
                                  Task(
                                      task: _task ?? task.task ?? " ",
                                      taskType: _getTaskTypeInt(_taskType ?? task.taskType) ,
                                      taskID: task.taskID,
                                      feedback: task.feedback,
                                      status: false,
                                      deadline: currentDateTime,
                                      dateCreated: currentDateTime));
                              Navigator.of(context).pop();
                            }),
                        FlatButton.icon(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                            color: Colors.red,
                            label: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              TeamMemberDatabaseService()
                                  .deleteTask(memberID, task.taskID);
                              Navigator.of(context).pop();
                            }),
                      ],
                    )
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

  String _getTaskTypeString(int val) {
    if (val == 1) {
      return 'Critical';
    } else if (val == 2) {
      return 'Normal';
    } else {
      return "Low";
    }
  }
}
