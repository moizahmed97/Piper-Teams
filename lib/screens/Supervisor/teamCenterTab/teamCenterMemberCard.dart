import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/models/simpleTeamMemberInfo.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/addUpdateLatestTaskForm.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/individualTeamMemberManagement.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/updateTask.dart';

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
                    child: AddNewTask()),
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
                    tooltip: 'Add new task',
                    onPressed: () {
                      _showAddTaskPanel();
                    }),
                trailing: IconButton(
                    tooltip: 'Team Member details',
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
          trailing: IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit task',
            onPressed: () {
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
                    child: UpdateTask(taskID: doc.grade,)),
              ),
            );
          },
          isScrollControlled: true);
            },
          ),
          subtitle: _getTaskTypeText(doc.taskType, context),
          title: Text(
            "${doc.task}",
          ),
          leading: RawMaterialButton(
            onPressed: () {},
            child: AspectRatio(
              aspectRatio: 1.33,
              child: Column(
                children: <Widget>[
                  completion(doc.status),
                  Text("Status:", style: TextStyle(color: Colors.black)),
                  ratingsDisplay(doc.status)
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

  Text ratingsDisplay(bool status) {
    if (status) {
      return Text(
        "Complete",
        style: TextStyle(color: Colors.teal),
      );
    } else {
      return Text(
        "Incomplete",
        style: TextStyle(color: Colors.orange),
      );
    }
  }

  CircleAvatar completion(bool complete) {
    if (!complete)
      return CircleAvatar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange,
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
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: Colors.deepOrange),
      );
    } else if (taskType == 2) {
      return Text(
        'Normal',
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.blue),
      );
    } else if (taskType == 3) {
      return Text(
        'Low',
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.green),
      );
    } else {
      return Text(
        'Unknown',
        style: Theme.of(context).textTheme.bodyText2,
      );
    }
  }
}
