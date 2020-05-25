import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/simpleTeamMemberInfo.dart';

class AttendanceTab extends StatefulWidget {
  @override
  _AttendanceTabState createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  Color attendance = Colors.grey;
  @override
  Widget build(BuildContext context) {
    // Get the Student Document that has Name and ID in each document
    final students = Provider.of<List<SimpleTeamMemberInfo>>(context);
     students.removeWhere(
                (element) => element.teamMemberID == "WillBeRemovedlater");
    if (students.length !=0) {
      return Container(
      child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4.0,
              color: attendanceColor(attendances[index]),
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: ListTile(
                  dense: true,
                  onLongPress: () {
                    setState(() {
                      attendances[index] = 0;
                    });
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          attendances[index] = 2;
                        });
                      }),
                  title: Center(
                    child: Text(
                      '${students[index].name}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.check,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          attendances[index] = 1;
                        });
                      })),
            );
          }),
    );
    } else {
      return Container(
        child: Center(child: Text("You do not have any Students yet", style: TextStyle(fontSize: 20),),),
      );
    }
  }

  final List<int> attendances = <int>[1, 2, 1, 2, 0, 0, 1, 2, 0];

  Color attendanceColor(int attendance) {
    if (attendance == 1)
      return Colors.green;
    else if (attendance == 2)
      return Colors.orange[600];
    else
      return Colors.grey[600];
  }
}
