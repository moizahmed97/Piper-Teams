import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'package:piper_team_tasks/screens/TeamMember/homeTab/updatePlanProgress.dart';

class PlanSummaryWidget extends StatefulWidget {
  @override
  _PlanSummaryWidgetState createState() => _PlanSummaryWidgetState();
}

class _PlanSummaryWidgetState extends State<PlanSummaryWidget> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SimpleUser>(context);
    return StreamBuilder(
        stream: Firestore.instance
            .collection("TeamMember/${user.uid}/Plan/")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            final List<DocumentSnapshot> documents = snapshot.data.documents;

            if (documents.length != 0) {
              return Card(
                child: Column(
                  children: _getPlanSummaryTiles(documents, context, user),
                ),
              );
            } else {
              return Card(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                elevation: 0.0,
                child: Text(
                  "You do not have any Plans yet",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.teal),
                ),
              );
            }
          }
        });
  }

  List<Widget> _getPlanSummaryTiles(documents, context, user) {
    return documents.map<Widget>((doc) {
      return ListTile(
        leading: IconButton(
          icon: Icon(Icons.edit, color: Colors.black),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 30.0, horizontal: 30.0),
                        child: UpdatePlanProgress(
                          teamMemberID: user.uid,
                          planType: doc['planType'],
                          planProgress: doc['progress'],
                        )),
                  );
                },
                isScrollControlled: true);
          },
          tooltip: 'Update Plan Progress',
        ),
        trailing: new CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 5.0,
          percent: doc['progress'],
          center: new Text(
            (doc['progress'] * 100).toInt().toString() + "%",
          ),
          progressColor: Colors.teal,
        ),
        subtitle: Text(
          '${doc['planType']}',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        title: Text(
          '${doc['plan']}',
        ),
        onLongPress: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 30.0),
                      child: UpdatePlanProgress(
                        teamMemberID: user.uid,
                        planType: doc['planType'],
                        planProgress: doc['progress'],
                      )),
                );
              },
              isScrollControlled: true);
        },
      );
    }).toList();
  }
}
