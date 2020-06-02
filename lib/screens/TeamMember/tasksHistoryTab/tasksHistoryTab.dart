import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/screens/TeamMember/tasksHistoryTab/tasksHistoryTaskCard.dart';
import 'package:piper_team_tasks/widgets/loading.dart';

class TasksHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the documents in the latest collection for this team member
    final tasks = Provider.of<List<Task>>(context);

    if (tasks != null) {
      tasks
          .removeWhere((element) => element.feedback == "Placeholder Feedback");
      // Remove all the tasks that have been completed
      tasks.removeWhere((element) => element.status == false);
      if (tasks.length != 0) {
        return Container(
          child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                // pass each task to the class to get a card

                return TaskCard(task: tasks[index]);
              }),
        );
      } else {
        return Container(
          child: Center(
            child: Text(
              "You do not have any old tasks yet",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    } else {
      return Container(child: Loading());
    }
  }
}
