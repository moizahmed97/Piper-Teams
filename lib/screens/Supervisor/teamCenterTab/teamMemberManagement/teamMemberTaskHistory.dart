import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'package:piper_team_tasks/screens/TeamMember/tasksHistoryTab/tasksHistoryTaskCard.dart';

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

            // Remove all the tasks that have been completed
            tasks.removeWhere((element) => element.status == false);
            return Container(
              child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(task: tasks[index]);
                  }),
            );
          } else {
            return Loading();
          }
        });
  }
}
