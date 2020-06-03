import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';
import 'package:piper_team_tasks/widgets/decoratorForForm.dart';

// ignore: must_be_immutable
class EditPlan extends StatefulWidget {
  String teamMember;
  String planText;
  DateTime startDate;
  DateTime endDate;
  String planType;
  bool edit;

  EditPlan(
      {this.teamMember,
      this.planText,
      this.startDate,
      this.endDate,
      this.planType,
      this.edit});

  @override
  _EditPlanState createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan> {
  final List<String> planTypes = ['Critical', 'Normal', 'Low'];

  bool picker = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.edit
          ? Text(
              "Create A New Plan",
              style: TextStyle(color: Colors.black),
            )
          : Text(
              "Edit Plan",
              style: TextStyle(color: Colors.black),
            ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.tealAccent,
                    child: widget.startDate == null
                        ? Text(
                            'Start Date',
                          )
                        : Text(DateFormat.yMMMd().format(widget.startDate)),
                    onPressed: () async {
                      final DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: widget.startDate == null
                            ? DateTime.now()
                            : widget.startDate,
                        firstDate: widget.startDate == null
                            ? DateTime.now().subtract(Duration(hours: 1))
                            : widget.startDate,
                        lastDate: widget.endDate == null
                            ? DateTime.now().add(Duration(days: 365))
                            : widget.endDate.add(Duration(days: 365)),
                      );
                      if (picked != null)
                        setState(() {
                          picker = false;
                          widget.startDate = picked;
                        });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  AbsorbPointer(
                    absorbing: picker,
                    child: RaisedButton(
                      color: Colors.tealAccent,
                      child: widget.endDate == null
                          ? Text('End Date')
                          : Text(DateFormat.yMMMd().format(widget.endDate)),
                      onPressed: () async {
                        final DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: widget.startDate == null
                                ? DateTime.now()
                                : widget.startDate,
                            firstDate: widget.startDate == null
                                ? DateTime.now().subtract(Duration(hours: 1))
                                : widget.startDate,
                            lastDate: widget.endDate == null
                                ? DateTime.now().add(Duration(days: 365))
                                : widget.endDate.add(Duration(days: 365)));
                        if (picked != null)
                          setState(() {
                            widget.endDate = picked;
                          });
                      },
                    ),
                  ),
                ]),
            Divider(),
            TextFormField(
              initialValue: widget.planText ?? '',
              decoration: textInputDecoration.copyWith(
                labelText: "Plan",
              ),
              validator: (val) =>
                  val.isEmpty ? 'Please Enter the Plan field' : null,
              onChanged: (val) => setState(() => widget.planText = val),
            ),
            DropdownButtonFormField(
              items: planTypes.map((planType) {
                return DropdownMenuItem(
                  value: planType,
                  child: Text('$planType'),
                );
              }).toList(),
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Select Priority',
                contentPadding: EdgeInsets.symmetric(vertical: 9),
              ),
              value: widget.planType == null ? 'Critical' : widget.planType,
              onChanged: (value) {
                setState(() {
                  widget.planType = value ?? "Critical";
                });
              },
              isExpanded: true,
            )
          ],
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
              picker = true;
              Navigator.of(context).pop();
            }),
        RaisedButton(
            color: Colors.teal[400],
            child: !widget.edit
                ? Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  )
                : Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
            onPressed: () async {
              picker = true;
              if (widget.edit) {
                TeamMemberDatabaseService().addPlan(
                    widget.teamMember,
                    widget.planText,
                    widget.startDate ?? DateTime.now(),
                    widget.endDate ?? DateTime.now(),
                    widget.planType ?? "Critical");
              } else
                TeamMemberDatabaseService().updatePlan(
                    widget.teamMember,
                    widget.planText,
                    widget.startDate ?? DateTime.now(),
                    widget.endDate ?? DateTime.now(),
                    widget.planType);
              Navigator.pop(context);
            }),
      ],
    );
  }
}
