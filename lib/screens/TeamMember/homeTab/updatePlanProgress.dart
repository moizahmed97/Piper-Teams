import 'package:flutter/material.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';

class UpdatePlanProgress extends StatefulWidget {
  @override
  _UpdatePlanProgressState createState() => _UpdatePlanProgressState();
  final String teamMemberID;
  final String planType;
  final double planProgress;
  UpdatePlanProgress({this.teamMemberID, this.planType, this.planProgress});
}

class _UpdatePlanProgressState extends State<UpdatePlanProgress> {
  final textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
    ),
  );

  final _formKey = GlobalKey<FormState>();

  // form values
  double _progress;

  @override
  Widget build(BuildContext context) {
    // Get the member ID from the widget tree using Provider
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Update Plan Progress',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              height: 30,
            ),
            Slider(
              value: _progress ?? widget.planProgress*100,
              onChanged: (val) {
                setState(() {
                  _progress = val;
                });
              },
              min: 0,
              max: 100,
              divisions: 10,
              activeColor: Colors.teal,
              label: "$_progress" ?? "0",
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                color: Colors.teal[400],
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  TeamMemberDatabaseService().updatePlanProgress(
                      widget.teamMemberID, widget.planType, _progress);
                  Navigator.of(context).pop();
                }),
          ],
        ));
  }
}
