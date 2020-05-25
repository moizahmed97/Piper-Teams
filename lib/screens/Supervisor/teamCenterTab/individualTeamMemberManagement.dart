import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/planEditingBox.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/teamMemberTaskHistory.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';
import 'package:piper_team_tasks/widgets/loading.dart';

import 'planManagement.dart';

class IndividualMemberManagement extends StatefulWidget {
  @override
  _IndividualMemberManagementState createState() =>
      _IndividualMemberManagementState();
}

class _IndividualMemberManagementState
    extends State<IndividualMemberManagement>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final member = Provider.of<String>(context);
    final user = Provider.of<SimpleUser>(context);

    return StreamBuilder(
      stream:
          Firestore.instance.collection("TeamMember/$member/Plan/").snapshots(),
      // Get all the documents in the plan collection for this student
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Loading();
        return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  actions: <Widget>[
                    FlatButton.icon(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        label:
                            Text("Delete", style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          // set up the buttons
                          Widget cancelButton = FlatButton(
                            child: Text(
                              "CANCEL",
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                          Widget continueButton = FlatButton(
                            child: Text("DELETE",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              StudentDatabaseService()
                                  .teamMemberLeavesSection(member, user.uid);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text(
                              "Delete Team Member",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                                "Are you sure you would like to Delete the Team Member?"),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        })
                  ],
                  title: Text(
                    'Manage Team Member',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  centerTitle: false,
                  bottom: TabBar(tabs: [
                    Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          Icon(Icons.event_note, color: Colors.white),
                          Text("Plan Details",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .button)
                        ])),
                    Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          Icon(Icons.insert_chart, color: Colors.white),
                          Text("Tasks",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .button)
                        ]))
                  ]),
                ),
                floatingActionButton: FloatingActionButton.extended(
                    label: Text(
                      "Add Plan",
                      style: Theme.of(context).textTheme.button,
                    ),
                    tooltip: 'Create a New Plan',
                    icon: Icon(Icons.add),
                    backgroundColor: Colors.teal,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return EditPlan(
                            student: member,
                            edit: true,
                          );
                        },
                      );
                    }),
                body: _buildDashboard(context, snapshot.data.documents)));
      },
    );
  }
}

TabBarView _buildDashboard(
    BuildContext context, List<DocumentSnapshot> documents) {
  return TabBarView(children: [
    Provider<List<DocumentSnapshot>>.value(
        // Pass down to the Tree all the documents we had gotten above ie In the Plans Collection for this student
        value: documents,
        child: PlanManagement()),
    TeamMemberHistory(),
  ]);
}
