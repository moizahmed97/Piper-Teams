import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';
import 'package:piper_team_tasks/widgets/decoratorForForm.dart';
import 'package:piper_team_tasks/widgets/quranInfo.dart';

// ignore: must_be_immutable
class EditPlan extends StatefulWidget {
  String student;
  String fromPlan;
  String toPlan;
  DateTime startDate;
  DateTime endDate;
  String planType;
  bool edit;

  EditPlan({this.student,
    this.fromPlan,
    this.toPlan,
    this.startDate,
    this.endDate,
    this.planType,
    this.edit});

  @override
  _EditPlanState createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan> {
  final List<String> planTypes = ['Memorization', 'Revision', 'Old Recall'];

  bool picker = true;

//  int calculateTotalAyats(int from, int to) {
//    List initialSurah = QuranHelper().juzInfo[from]; //[4, 148]
//    List finalSurah = QuranHelper().juzInfo[to + 1]; //[11, 6]
//
//    int cumVerse1 = (QuranHelper().surahInfo[initialSurah[0]][0] as int) +
//        initialSurah[1]; // 493 + 148
//    int cumVerse2 = (QuranHelper().surahInfo[finalSurah[0]][0] as int) +
//        (finalSurah[1] - 1); //1473 + (6-1)
//
//    int totalAyats = cumVerse2 - cumVerse1;
//
//    return totalAyats;
//  }

  int _getAssignmentTypeInt(String val) {
    if (val == 'Memorization') {
      return 1;
    } else if (val == 'Revision') {
      return 2;
    } else {
      return 3;
    }
  }

  List<Task> generateMultipleAssignments(DateTime fromDate,
      DateTime toDate, int from, int to, String assignmentType) {
    int duration = toDate
        .difference(fromDate)
        .inDays;
    //print("duration: " + duration.toString());

    List initialSurah = QuranHelper().juzInfo[from]; //[4, 24]
    List finalSurah = QuranHelper().juzInfo[to + 1]; //[11, 6]

    int cumVerse1 = (QuranHelper().surahInfo[initialSurah[0]][0] as int) +
        initialSurah[1]; // 493 + 24 = 517
    int cumVerse2 = (QuranHelper().surahInfo[finalSurah[0]][0] as int) +
        (finalSurah[1] - 1); //1473 + (6-1) = 1478
    double controller = cumVerse1.toDouble();

    int totalAyats = cumVerse2 - cumVerse1; //961

    double ayatsPerDay = totalAyats / duration;
    // print(ayatsPerDay);
    List<Task> allAssignments = List<Task>();

    DateTime deadline = fromDate;
    //for (int index = 0; index < duration; index++) {}

    //int i = 0;
    while (controller < cumVerse2) {
      allAssignments.add(Task(
        dateCreated: fromDate,
        deadline: deadline,
        taskType: _getAssignmentTypeInt(assignmentType),
        task: QuranHelper().surahInfo[index(controller)][3] as String,


      ));

      controller = controller + ayatsPerDay;
      deadline = deadline.add(Duration(days: 1));
    }
    return allAssignments;
  }

  int index(double control) {
    int i;
    for (i = 1; i <= 114; i++)
      if (control <
          ((QuranHelper().surahInfo[i][0] as int) +
              (QuranHelper().surahInfo[i][1] as int))) break;
    return i;
  }

  int ayat(int control) {
    int i;
    for (i = 1; i <= 114; i++)
      if (control <
          ((QuranHelper().surahInfo[i][0] as int) +
              (QuranHelper().surahInfo[i][1] as int))) break;

    return (control - QuranHelper().surahInfo[i][0] as int);
  }

  @override
  Widget build(BuildContext context) {
    //DateTime endDate = startDate.add(Duration(days: 30));

    return AlertDialog(
      title: Text(
        "Create A New Plan",
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
                    child: widget.startDate == null
                        ? Text('Start Date')
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
                  AbsorbPointer(
                    absorbing: picker,
                    child: RaisedButton(
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
              initialValue: widget.fromPlan ?? '',
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(
                  labelText: "From", hintText: 'eg. 10'),
              validator: (val) =>
              val.isEmpty ? 'Please Enter the From field' : null,
              onChanged: (val) => setState(() => widget.fromPlan = val),
            ),
            Divider(),
            TextFormField(
              initialValue: widget.toPlan ?? '',
              keyboardType: TextInputType.number,
              decoration: textInputDecoration.copyWith(
                  labelText: "To", hintText: 'eg. 20'),
              validator: (val) =>
              val.isEmpty ? 'Please Enter the to Field' : null,
              onChanged: (val) => setState(() => widget.toPlan = val),
            ),
            widget.edit
                ? DropdownButtonFormField(
              items: planTypes.map((planType) {
                return DropdownMenuItem(
                  value: planType,
                  child: Text('$planType'),
                );
              }).toList(),
              value: widget.planType == null
                  ? 'Memorization'
                  : widget.planType,
              onChanged: (value) {
                setState(() {
                  widget.planType = value ?? "Memorization";
                });
              },
              isExpanded: true,
            )
                : Container(
              padding: EdgeInsets.all(24),
              //color: Colors.grey[300],
              child: Text(
                widget.planType,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle1,
              ),
            ),
            // !widget.edit ? Divider(color: Colors.black,) : Divider()
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
                StudentDatabaseService().addPlan(
                    widget.student,
                    "Juz " + widget.fromPlan,
                    "Juz " + widget.toPlan,
                    widget.startDate,
                    widget.endDate,
                    widget.planType ?? "Memorization");
                List<Task> all = generateMultipleAssignments(
                    widget.startDate,
                    widget.endDate,
                    int.parse(widget.fromPlan),
                    int.parse(widget.toPlan),
                    widget.planType);
                StudentDatabaseService().addTasksFromPlan(widget.student, all);
              } else
                StudentDatabaseService().updatePlan(
                    widget.student,
                    widget.fromPlan,
                    widget.toPlan,
                    widget.startDate,
                    widget.endDate,
                    widget.planType);
              Navigator.pop(context);
            }),
      ],
    );
  }
}
