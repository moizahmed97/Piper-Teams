import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/screens/Student/taskCard.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'nextPlanAssignmetnCard.dart';

class TasksHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the documents in the assignments collection for this student
    final tasks = Provider.of<List<Task>>(context);

    if (tasks != null) {
      tasks
          .removeWhere((element) => element.feedback == "Placeholder Feedback");
      // Remove all the assignments before the current date time
      tasks
          .removeWhere((element) => element.deadline.isBefore(DateTime.now()));
      if (tasks.length != 0) {
        return Container(
          child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                // pass each assignment to the class to get a card
                if (index == 0) {
                  return Column(
                    children: <Widget>[
                      Card(
                        elevation: 0.0,
                        child: Text(
                          "My Next Plan Assignment",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      NextPlanTaskCard(
                              task: tasks[index]),
                          SizedBox(height: 50),
                          Divider(thickness: 3,),
                      Card(
                        elevation: 0.0,
                        child: Text(
                          "Upcoming Plan Assignments",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  );
                } else {
                  return TaskCard(task: tasks[index]);
                } 
              }),
        );
      } else {
        return Container(
          child: Center(
            child: Text(
              "You do not have any Plans yet",
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
