import 'package:flutter/material.dart';
import 'package:piper_team_tasks/models/task.dart';

class TaskTile extends StatefulWidget {
  final Task task;

  TaskTile({this.task});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      subtitle: _getAssignmentTypeText(widget.task.taskType),
      secondary: _getAssignmentTypeIcon(widget.task.taskType),
      title: Text(
        '${widget.task.task}',
      ),
      value: checked,
      onChanged: (bool value) {
        setState(() {
          checked = value;
        });
      },
    );
  }

  Icon _getAssignmentTypeIcon(int taskType) {
    if (taskType == 1) {
      return Icon(
        Icons.priority_high,
        color: Colors.black,
      );
    } else if (taskType == 2) {
      return Icon(
        Icons.work,
        color: Colors.black,
      );
    } else {
      return Icon(
        Icons.calendar_today,
        color: Colors.black,
      );
    }
  }

  Text _getAssignmentTypeText(int assignmentType) {
    if (assignmentType == 1) {
      return Text(
        'Critical',
        style: Theme.of(context).textTheme.bodyText2,
      );
    } else if (assignmentType == 2) {
      return Text(
        'Normal',
        style: Theme.of(context).textTheme.bodyText2,
      );
    } else {
      return Text(
        'Low',
        style: Theme.of(context).textTheme.bodyText2,
      );
    }
  }
}
