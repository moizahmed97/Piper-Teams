import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piper_team_tasks/screens/TeamMember/homeTab/latestTaskTilesBuilder.dart';
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
  var _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SimpleUser>(context);
    return Scaffold(
        key: _key,
        body: StreamBuilder<DocumentSnapshot>(
            stream: TeamMemberDatabaseService().getTeamMemberDoc(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data['supervisor'] == "")
                  return Container(
                      child: RawMaterialButton(
                    splashColor: Colors.teal,
                    child: Center(
                        child: Text(
                      "Press Here \n to Join a Team",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    )),
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
                                  validator: (val) => val.isEmpty
                                      ? 'Please Enter a Code'
                                      : null,
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
                                      bool test =
                                          await TeamMemberDatabaseService()
                                              .checkIfTeamExists(sectionCode);

                                      if (test) {
                                        TeamMemberDatabaseService()
                                            .addTeamMemberToTeam(
                                                user.uid,
                                                snapshot.data['name'],
                                                sectionCode)
                                            .then((value) {
                                          TeamMemberDatabaseService()
                                              .addTeamMembersTeam(
                                                  sectionCode, user.uid);
                                          Navigator.of(context).pop();
                                        }).catchError((err) {
                                          // Display a Snackbar
                                          Navigator.pop(context);

                                          _key.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Cannot join the team at the moment'),
                                            duration: Duration(seconds: 5),
                                          ));

                                          /*  IN CASE WE WOULD LIKE TO SHOW ANOTHER DIALOG BOX INSTEAD OF A SNACKBAR 
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content:
                                                    Text("No such Team found"),
                                                actions: <Widget>[
                                                  RaisedButton(
                                                      color: Colors.teal[400],
                                                      child: Text(
                                                        'OK',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                ],
                                              );
                                            });

                                        */
                                        });
                                      } else {
                                        Navigator.pop(context);

                                        _key.currentState.showSnackBar(SnackBar(
                                          content: Text('No Such Team Found'),
                                          duration: Duration(seconds: 5),
                                        ));
                                      }
                                    }),
                              ],
                            );
                          });
                    },
                  ));
                else // If the team member already has a team
                  return StreamBuilder<List<Task>>(
                      stream: DatabaseService().getAllTasks(user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Task> latestTasks = snapshot.data;
                          latestTasks.removeWhere(
                              (element) => element.feedback == 'completed');
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
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),

                                  SizedBox(height: 5.0),

                                  (latestTasks.length == 0)
                                      ? ListTile(
                                          leading: Icon(Icons.info_outline),
                                          title: Text("No Tasks for now"),
                                        )
                                      : Card(
                                          elevation: 4.0,
                                          child: LatestTaskTilesBuilder(
                                              latestTasks: latestTasks)),

                                  SizedBox(height: 10.0),
                                  Card(
                                    elevation: 0.0,
                                    child: Text(
                                      "Plan Summary",
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
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
            }));
  }
}
