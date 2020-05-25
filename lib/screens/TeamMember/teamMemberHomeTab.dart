import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';
import 'package:piper_team_tasks/widgets/decoratorForForm.dart';
import 'package:piper_team_tasks/widgets/loading.dart';

import 'planSummary.dart';

class TeamMemberHomeTab extends StatefulWidget {
  @override
  _TeamMemberHomeTabState createState() => _TeamMemberHomeTabState();
}

class _TeamMemberHomeTabState extends State<TeamMemberHomeTab> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SimpleUser>(context);

    return StreamBuilder<DocumentSnapshot>(
        stream: StudentDatabaseService().getTeamMemberDoc(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['supervisor'] == "")
              return Container(
                  child: RawMaterialButton(
                splashColor: Colors.teal,
                child: Center(
                    child: Text("Press Here \nto Join A Team",
                        textAlign: TextAlign.center)),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        String sectionCode;
                        return AlertDialog(
                          title: Text(
                            "Enter The Team Code",
                            style: TextStyle(color: Colors.black),
                          ),
                          content: Form(
                            child: TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Code'),
                              validator: (val) =>
                                  val.isEmpty ? 'Please Enter a Code' : null,
                              onChanged: (val) =>
                                  setState(() => sectionCode = val),
                            ),
                          ),
                          actions: <Widget>[
                            RaisedButton(
                                color: Colors.teal[400],
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                }),
                            RaisedButton(
                                color: Colors.teal[400],
                                child: Text(
                                  'Enter',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  StudentDatabaseService().addTeamMemberToTeam(
                                      user.uid,
                                      snapshot.data['name'],
                                      sectionCode);
                                  StudentDatabaseService().addTeamMembersTeam(
                                      sectionCode, user.uid);
                                  Navigator.of(context).pop();
                                }),
                          ],
                        );
                      });
                },
              ));
            else
              return StreamBuilder<List<Task>>(
                  stream: DatabaseService().getLatestTask(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Task> latestTasks = snapshot.data;
                      // remove the placeholder latestAssignment
                      latestTasks.removeWhere((element) =>
                          element.feedback == "Placeholder Feedback");
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 5.0),
                        child: ListView(children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Used a card here for this text because it seems to align well with the card below
                              Card(
                                elevation: 0.0,
                                child: Text(
                                  "My Next Task",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),

                              SizedBox(height: 5.0),

                              Card(
                                elevation: 4.0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _getLatestAssignmentTiles(
                                      latestTasks, context),
                                ),
                              ),

                              SizedBox(height: 10.0),
                              Card(
                                elevation: 0.0,
                                child: Text(
                                  "Plan Summary",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              SizedBox(height: 5.0),

                              PlanSummaryWidget(),
                            ],
                          ),
                        ]),
                      );
                    } else {
                      return Container(
                        child: Loading(),
                      );
                    }
                  });
          } else
            return Loading();
        });
  }

  List<Widget> _getLatestAssignmentTiles(latestAssignment, context) {
      return latestAssignment.map<Widget>((doc) {
      return ListTile(
        leading: _getAssignmentTypeIcon(doc.taskType),
        title: _getAssignmentTypeText(doc.taskType),
        subtitle: Text(
          '${doc.task}',
        ),
      );
    }).toList();
    
     
  }

  Icon _getAssignmentTypeIcon(int assignmentType) {
    if (assignmentType == 1) {
      return Icon(
        Icons.assignment,
        color: Colors.black,
      );
    } else if (assignmentType == 2) {
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

  Text _getAssignmentTypeText(int assignmentType) {
    if (assignmentType == 1) {
      return Text(
        'Critical',
        style: Theme.of(context).textTheme.bodyText2,
      );
    } else if (assignmentType == 2) {
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
