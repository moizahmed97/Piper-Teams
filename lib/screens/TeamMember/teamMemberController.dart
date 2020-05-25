import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/task.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/screens/TeamMember/tasksHistoryTab.dart';
import 'package:piper_team_tasks/screens/TeamMember/teamMemberHomeTab.dart';
import 'package:piper_team_tasks/screens/TeamMember/teamMemberProfileTab.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';

class TeamMemberController extends StatefulWidget {
  @override
  _TeamMemberControllerState createState() => _TeamMemberControllerState();
}

class _TeamMemberControllerState extends State<TeamMemberController> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Text _changeAppBarTitle(int index) {
    if (index == 0)
      return Text(
        'My Dashboard',
        style: Theme.of(context).textTheme.headline6,
      );
    else
      return Text(
        'Task History',
        style: Theme.of(context).textTheme.headline6,
      );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = Provider.of<SimpleUser>(context);

    return StreamProvider<List<Task>>.value(
      value: DatabaseService().getTeamMemberTasks(user.uid),
      // Get all the tasks for the team Member ie all the documents in the tasks collection for him
      child: _scaffold(),
    );
  }

  Scaffold _scaffold() {
    final user = Provider.of<SimpleUser>(context);

    return Scaffold(
      appBar: AppBar(
        title: _changeAppBarTitle(_selectedIndex),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StreamProvider<DocumentSnapshot>.value(
                              value: TeamMemberDatabaseService()
                                  .getTeamMemberDoc(user.uid),
                              child: ProfileTabS())),
                );
              },
              icon: Icon(Icons.person, color: Colors.white),
              label: Text("Profile", style: TextStyle(color: Colors.white),)),
        ],
      ),
      body: _buildMainDashboard(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text(
              'Task History',
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Container _buildMainDashboard() {
    if (_selectedIndex == 0)
      return Container(
        child: TeamMemberHomeTab(),
      );
    else {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
          child: TasksHistory());
    }
  }
}
