import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/widgets/loading.dart';

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
            .collection("Student/${user.uid}/Plan/")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          } else {
            final List<DocumentSnapshot> documents = snapshot.data.documents;
            documents.removeWhere(
                (element) => element.data['plan'] == "Placeholder plan");
            if (documents.length != 0) {
              return Card(
                child: Column(
                  children: _getPlanSummaryTiles(documents, context),
                ),
              );
            } else {
              return Card(
                margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                elevation: 0.0,
                child: Text(
                  "You do not have any Plans yet",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.green),
                ),
              );
            }
          }
        });
  }

  List<Widget> _getPlanSummaryTiles(documents, context) {
    return documents.map<Widget>((doc) {
      return ListTile(
        leading: Icon(Icons.skip_previous, color: Colors.black),
        trailing: new CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 5.0,
          percent: doc['progress'],
          center: new Text(
            (doc['progress'] * 100).toInt().toString() + "%",
          ),
          progressColor: Colors.green,
        ),
        title: Text(
          '${doc['PlanType']}',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        subtitle: Text(
          '${doc['from']} to ${doc['to']}',
        ),
      );
    }).toList();
  }
}
