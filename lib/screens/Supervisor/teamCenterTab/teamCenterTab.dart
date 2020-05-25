import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/teamCenterMemberCard.dart';
import 'package:piper_team_tasks/models/simpleTeamMemberInfo.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'package:piper_team_tasks/models/task.dart';


class TeamCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the Stream of team member documents which have their Name and ID as their fields
    final teamMembers = Provider.of<List<SimpleTeamMemberInfo>>(context);

    if (teamMembers != null) {
      teamMembers.removeWhere(
          (element) => element.teamMemberID == "Placeholder teamMemberID");
      if (teamMembers.length != 0) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              itemCount: teamMembers.length,
              itemBuilder: (BuildContext context, int index) {
                // Build the card for each team member Document
                // Wrap this in the stream for latest task for teamMembers[index].teamMemberID
                return StreamProvider<List<Task>>.value(
                    value: DatabaseService()
                        .getLatestTask(teamMembers[index].teamMemberID),
                    child: TeamCenterMemberCard(teamMember: teamMembers[index]));
              }),
        );
      } else {
        return Container(
          child: Center(
            child: Text(
              "You do not have any Team Members yet",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    } else {
      return Container(
        child: Loading(),
      );
    }
  }
}
