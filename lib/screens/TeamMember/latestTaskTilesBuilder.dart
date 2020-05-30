import 'package:flutter/material.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'taskTile.dart';

class LatestTaskTilesBuilder extends StatelessWidget {
  final List<Task> latestTasks;

  LatestTaskTilesBuilder({this.latestTasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return TaskTile(task: latestTasks[index]);
        },
        itemCount: latestTasks.length,
      ),
    );
  }
}
