import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/models/simpleTeamMemberInfo.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/addUpdateLatestTaskForm.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/individualTeamMemberManagement.dart';
import 'package:piper_team_tasks/widgets/loading.dart';

// ignore: must_be_immutable
class TeamCenterMemberCard extends StatelessWidget {
  // The Current Team member Object has Name and ID
  final SimpleTeamMemberInfo teamMember;

  TeamCenterMemberCard({this.teamMember});

  String defaultGrade = "Incomplete";

  @override
  Widget build(BuildContext context) {
    void _showAddTaskPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                child: Provider<String>.value(
                    // Pass the value of teamMember ID down the tree (To Management) using Provider
                    value: teamMember.teamMemberID,
                    child: AddUpdateTask()),
              ),
            );
          },
          isScrollControlled: true);
    }

    // All the latest tasks for this team member Stream defined in teamCenterTab.dart
    final latestTasks = Provider.of<List<Task>>(context);
    if (latestTasks != null) {
      latestTasks
          .removeWhere((element) => element.feedback == "Placeholder Feedback");
      return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
                title: Center(
                  child: Text(
                    '${teamMember.name}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                leading: IconButton(
                    icon: Icon(Icons.add, color: Colors.black, size: 40.0),
                    onPressed: () {
                      _showAddTaskPanel();
                    }),
                trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right,
                        color: Colors.black, size: 40.0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Provider<String>.value(
                                // Pass the value of member ID down the tree (To Management) using Provider
                                value: teamMember.teamMemberID,
                                child: IndividualMemberManagement())),
                      );
                    })),
            Column(
              children: _getLatestTaskTile(latestTasks, context),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    } else {
      return Loading();
    }
  }

  List<Widget> _getLatestTaskTile(latestTask, context) {
    if (latestTask.length != 0) {
      return latestTask.map<Widget>((doc) {
        return ListTile(
          leading: _getTaskTypeIcon(doc.taskType),
          title: _getTaskTypeText(doc.taskType, context),
          subtitle: Text(
            "${doc.task}",
          ),
          trailing: RawMaterialButton(
            onPressed: () {},
            child: AspectRatio(
              aspectRatio: 1.33,
              child: Column(
                children: <Widget>[
                  completion(doc.grade),
                  Text("Rating:", style: TextStyle(color: Colors.black)),
                  ratingsDisplay(doc.grade)
                ],
              ),
            ),
          ),
        );
      }).toList();
    } else {
      List<Widget> l = [
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("No Tasks for now"),
        )
      ];
      return l;
    }
  }

  Icon _getTaskTypeIcon(int taskType) {
    if (taskType == 1) {
      return Icon(
        Icons.assignment,
        color: Colors.black,
      );
    } else if (taskType == 2) {
      return Icon(
        Icons.skip_previous,
        color: Colors.black,
      );
    } else {
      return Icon(
        Icons.skip_previous,
        color: Colors.black,
      );
    }
  }

  Text ratingsDisplay(String rating) {
    switch (rating) {
      case "Poor":
        return Text(
          "Poor",
          style: TextStyle(color: Colors.red),
        );
      case "Good":
        return Text(
          "Good",
          style: TextStyle(color: Colors.orange),
        );
      case "Very Good":
        return Text(
          "Very Good",
          style: TextStyle(color: Colors.teal),
        );
      case "Excellent":
        return Text(
          "Excellent",
          style: TextStyle(color: Colors.teal),
        );
      default:
        return Text(
          "Incomplete",
          style: TextStyle(color: Colors.red),
        );
    }
  }

  CircleAvatar completion(String complete) {
    if (complete == "Incomplete")
      return CircleAvatar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        maxRadius: 9,
        child: Icon(
          Icons.close,
          size: 18,
        ),
      );
    else
      return CircleAvatar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        maxRadius: 9,
        child: Icon(
          Icons.check,
          size: 18,
        ),
      );
  }

  int gradeVal(String grades) {
    switch (grades) {
      case "Poor":
        return 1;
      case "Good":
        return 2;
      case "Very Good":
        return 3;
      case "Excellent":
        return 4;
      default:
        return 0;
    }
  }

  Text _getTaskTypeText(int taskType, context) {
    if (taskType == 1) {
      return Text(
        'Critical',
        style: Theme.of(context).textTheme.bodyText2,
      );
    } else if (taskType == 2) {
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
