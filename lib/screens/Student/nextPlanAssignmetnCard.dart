import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piper_team_tasks/models/task.dart';

class NextPlanTaskCard extends StatelessWidget {
  final Task task;

  NextPlanTaskCard({this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical : 3, horizontal: 8 ),
      child: Card(
        elevation: 4.0,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          SizedBox(height: 10.0),
          Text( "Deadline: " +
            DateFormat.yMMMd().format(
                task.deadline), style: Theme
              .of(context)
              .textTheme
              .overline,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assignment, color: Colors.black),
            trailing: displayGrade(task.grade),
            title: displayAssignmentType(task.taskType, context),
            subtitle: Text(
              "${task.task}"
            ),
          )
        ]),
      ),
    );
  }

  Text displayAssignmentType(assignmentType, context) {
    if (assignmentType == 1) {
      return Text(
        'Memorization',
        style: Theme.of(context).textTheme.bodyText2,
      );
    } else if (assignmentType == 2) {
      return Text(
        'Revision',
        style: Theme.of(context).textTheme.bodyText2,
      );
    } else {
      return Text(
        'Old Recall',
        style: Theme.of(context).textTheme.bodyText2,
      );
    }
  }

  Text displayGrade(value) {
    return Text(
      value,
      style: gradeStyle(value),
    );
  }

  TextStyle gradeStyle(grade) {
    print(grade.runtimeType);
    if (grade == "Excellent")
      return TextStyle(color: Colors.teal);
    else if (grade == "Very Good")
      return TextStyle(color: Colors.teal);
    else if (grade == "Good")
      return TextStyle(color: Colors.yellow);
    else
      return TextStyle(color: Colors.orange);
  }
}
