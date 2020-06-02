import 'package:flutter/material.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';

class TaskTile extends StatefulWidget {
  final Task task;

  TaskTile({this.task});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool checked;

  @override
  Widget build(BuildContext context) {
        final user = Provider.of<SimpleUser>(context);

    return CheckboxListTile(
      subtitle: _getAssignmentTypeText(widget.task.taskType, checked ?? widget.task.status),
      secondary: _getAssignmentTypeIcon(widget.task.taskType),
      title: Text(
        '${widget.task.task}',
        style: TextStyle(
            color: _getTaskTextColor(widget.task.taskType),
            decorationThickness: 2.85,
            decoration:
                (checked ?? widget.task.status) ? TextDecoration.lineThrough : TextDecoration.none),
      ),
      value: checked ?? widget.task.status,
      onChanged: (bool value) {
        setState(() {
          checked = value;
          DatabaseService().updateTaskStatus(user.uid, widget.task.taskID, checked);
        });
      },
    );
  }

  Icon _getAssignmentTypeIcon(int taskType) {
    if (taskType == 1) {
      return Icon(
        Icons.priority_high,
        color: Colors.deepOrange,
      );
    } else if (taskType == 2) {
      return Icon(
        Icons.work,
        color: Colors.blue,
      );
    } else {
      return Icon(
        Icons.calendar_today,
        color: Colors.green,
      );
    }
  }

  Text _getAssignmentTypeText(int assignmentType, bool checked) {
    TextStyle incompleteStyle = Theme.of(context).textTheme.bodyText2;
    TextStyle completedStyle = Theme.of(context).textTheme.bodyText2.copyWith(
          decoration: TextDecoration.lineThrough,
          decorationThickness: 2.85,
        );

    if (assignmentType == 1) {
      return Text(
        'Critical',
        style: checked
            ? completedStyle.copyWith(color: Colors.deepOrange)
            : incompleteStyle.copyWith(color: Colors.deepOrange),
      );
    } else if (assignmentType == 2) {
      return Text(
        'Normal',
        style: checked
            ? completedStyle.copyWith(color: Colors.blue)
            : incompleteStyle.copyWith(color: Colors.blue),
      );
    } else {
      return Text(
        'Low',
        style: checked
            ? completedStyle.copyWith(color: Colors.green)
            : incompleteStyle.copyWith(color: Colors.green),
      );
    }
  }

  Color _getTaskTextColor(int assignmentType) {
    if (assignmentType == 1) {
      return Colors.deepOrange;
    } else if (assignmentType == 2) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }
}
