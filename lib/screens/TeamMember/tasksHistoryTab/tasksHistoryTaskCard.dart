import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piper_team_tasks/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  TaskCard({this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical : 3, horizontal: 8 ),
      child: Card(
        elevation: 4.0,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          SizedBox(height: 10.0),
          Text( "Date Created: " +
            DateFormat.yMMMd().format(
                task.dateCreated), style: Theme
              .of(context)
              .textTheme
              .overline,
          ),
          Divider(),
          ListTile(

            leading: Icon(Icons.assignment, color: Colors.black),
          trailing: Text("Completed"),
            subtitle: displayTaskType(task.taskType, context),
            title: Text(
              "${task.task}"
            ),
          )
        ]),
      ),
    );
  }

  Text displayTaskType(taskType, context) {
    if (taskType == 1) {
      return Text(
        'Critical',
        style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.deepOrange),
      );
    } else if (taskType == 2) {
      return Text(
        'Normal',
        style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.blue),
      );
    } else {
      return Text(
        'Low',
        style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.green),
      );
    }
  }

 

 
}
