import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'package:piper_team_tasks/screens/TeamMember/taskCard.dart';
import 'package:piper_team_tasks/screens/TeamMember/nextPlanTaskCard.dart';

class TeamMemberHistory extends StatefulWidget {
  @override
  _TeamMemberHistoryState createState() => _TeamMemberHistoryState();
}

class _TeamMemberHistoryState extends State<TeamMemberHistory> {
  @override
  Widget build(BuildContext context) {
    final teamMember = Provider.of<String>(context);

    return StreamBuilder(
        stream: DatabaseService().getTeamMemberTasks(teamMember),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<Task> tasks = snapshot.data;
            tasks.removeWhere(
                (element) => element.feedback == "Placeholder Feedback");
            tasks.removeWhere(
                (element) => element.deadline.isBefore(DateTime.now()));
            return Container(
              child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Card(
                            elevation: 0.0,
                            child: Text(
                              "Next Plan Tasks",
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
                              "Upcoming Plan Tasks",
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
            return Loading();
          }
        });
  }
}
