import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/simpleTeamMemberInfo.dart';

class AttendanceTab extends StatefulWidget {
  @override
  _AttendanceTabState createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  Color attendance = Colors.grey;
  @override
  Widget build(BuildContext context) {
    // Get the Team Member Document that has Name and ID in each document
    final teamMembers = Provider.of<List<SimpleTeamMemberInfo>>(context);
    teamMembers.removeWhere(
        (element) => element.teamMemberID == "Placeholder teamMemberID");
    if (teamMembers.length != 0) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: (teamMembers.length == 1)
                  ? Text(
                      "You have only ${teamMembers.length} Member in your team",
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  : Text(
                      "You have a ${teamMembers.length} Members in your team",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: teamMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4.0,
                    color: Colors.teal[700],
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: ListTile(
                      dense: true,
                      onLongPress: () {},
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      title: Center(
                        child: Text(
                          '${teamMembers[index].name}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text(
              "You do not have any Team Members yet \n \n Press the Plus Button to share your code",
              style: TextStyle(fontSize: 18),
            ),
        ),
      );
    }
  }
}
