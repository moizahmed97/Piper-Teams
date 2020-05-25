import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/models/simpleTeamMemberInfo.dart';
import 'package:piper_team_tasks/screens/Supervisor/attendanceTab/attendanceTab.dart';
import 'package:piper_team_tasks/screens/Supervisor/teamCenterTab/teamCenterTab.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'package:share/share.dart';
import 'supervisorProfileTab.dart';

class SupervisorController extends StatefulWidget {
  @override
  _SupervisorControllerState createState() => _SupervisorControllerState();
}

class _SupervisorControllerState extends State<SupervisorController>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Text _changeAppBarTitle(int index) {
    if (index == 0)
      return Text(
        'Team Center',
        style: Theme.of(context).textTheme.headline6,
      );
    else
      return Text(
        'Attendance',
        style: Theme.of(context).textTheme.headline6,
      );
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SimpleUser>(context);
    if (user != null) {
      return StreamProvider<List<SimpleTeamMemberInfo>>.value(
        value: DatabaseService()
            .getTeamMembersInTeam(user.uid, "Team"),
        // Get all the students (as documents) in the section specified as parameter for this InstructorX
        child: Scaffold(
            appBar: AppBar(
              title: _changeAppBarTitle(_selectedIndex),
              //centerTitle: true,
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileTab()),
                      );
                    },
                    icon: Icon(Icons.person,color: Colors.white,),
                    label: Text("Profile", style: TextStyle(color: Colors.white),)),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text(
                    'Team Center',
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  title: Text(
                    'Attendance',
                  ),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: _onItemTapped,
            ),
          body: _buildMainDashboard(),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
          floatingActionButton: FloatingActionButton.extended(
            //ptooltip: "Add New Students",
            icon: Icon(Icons.add),
            label: Text("Add Team Member", style: Theme
                .of(context)
                .textTheme
                .button,),
            backgroundColor: Colors.teal[700],
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text("Share This Code:", style: TextStyle(
                      color: Colors.black),),
                  content: SelectableText(user.uid, style: TextStyle(
                      fontSize: 12),),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: user.uid));
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.content_copy), color: Colors.teal,
                    ),
                    IconButton(
                      onPressed: () {
                        Share.share(user.uid);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.share), color: Colors.teal,
                    )
                  ],

                );
              });
            },
          ),
        ),
      );
    } else {
      return Loading();
    }
  }

  Container _buildMainDashboard() {
    if (_selectedIndex == 0)
      return Container(child: TeamCenter());
    else
      return Container(child: AttendanceTab());
  }
}
