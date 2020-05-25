import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/planEditingBox.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlanManagement extends StatefulWidget {
  @override
  _PlanManagementState createState() => _PlanManagementState();
}

class _PlanManagementState extends State<PlanManagement> {
  static int _current = 0;
  final controller = PageController(initialPage: _current);

  Text status(bool status) {
    if (status)
      return Text("Active", style: Theme.of(context).textTheme.subtitle1);
    else
      return Text("Inactive", style: Theme.of(context).textTheme.subtitle1);
  }

  @override
  Widget build(BuildContext context) {
    final List<DocumentSnapshot> documents =
        Provider.of<List<DocumentSnapshot>>(context);
    final teamMember = Provider.of<String>(context);

    documents
        .removeWhere((element) => element.data['plan'] == "Placeholder plan");

    if (documents.length != 0) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
        child: ListView(
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
                Widget>[
              Card(
                elevation: 0.0,
                child: Text(
                  "Plan Management",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1 / 1.2,
                    child: PageView.builder(
                      itemCount: documents.length,
                      onPageChanged: (index) {
                        _current = index;
                      },
                      controller: controller,
                      itemBuilder: (context, index) {
                        return Card(
                            elevation: 0,
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: CircularPercentIndicator(
                              radius: MediaQuery.of(context).size.width - 50,
                              lineWidth: 15,
                              percent: documents[index].data["progress"],
                              backgroundColor: Colors.grey[400],
                              progressColor: Colors.teal[900],
                              header: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Priority: " + documents[index].data["planType"],
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    Divider(
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Date Starting: " +
                                          DateFormat.yMMMd().format(
                                              documents[index]
                                                  .data["dateStarting"]
                                                  .toDate()),
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ]),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    (documents[index].data["progress"] * 100)
                                            .toInt()
                                            .toString() +
                                        "%",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    (documents[index].data["plan"]),
                                    textAlign: TextAlign.center,
                                    style:
                                  
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  SizedBox(height: 10),
                                  FlatButton.icon(
                                      color: Colors.red,
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "Delete Plan",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        TeamMemberDatabaseService().deletePlan(
                                            teamMember,
                                            documents[index].data["planType"]);
                                      }),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton.icon(
                                            color: Colors.blue,
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            label: Text("Edit Plan",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditPlan(
                                                      teamMember: teamMember,
                                                      startDate: documents[
                                                              index]
                                                          .data["dateStarting"]
                                                          .toDate(),
                                                      endDate: documents[index]
                                                          .data["dateEnding"]
                                                          .toDate(),
                                                      planText: documents[index]
                                                          .data["plan"],
                                                      planType: documents[index]
                                                          .data["planType"],
                                                      edit: false,
                                                    );
                                                  });
                                            }),
                                      ]),
                                ],
                              ),
                              footer: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Date Ending: " +
                                        DateFormat.yMMMd().format(
                                            documents[index]
                                                .data["dateEnding"]
                                                .toDate()),
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  SizedBox(height: 20)
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: documents.length,
                      effect: WormEffect(
                        spacing: 16.0,
                        dotColor: Colors.grey[400],
                        activeDotColor: Colors.teal[900],
                      ),
                    ),
                  ),
                ],
                overflow: Overflow.clip,
              ),
              SizedBox(height: 10.0),
            ])
          ],
        ),
      );
    } else {
      return Container(
          child: Center(
              child: Text("There are no plans for this Team member yet",
                  style: Theme.of(context).textTheme.subtitle1)));
    }
  }
}
