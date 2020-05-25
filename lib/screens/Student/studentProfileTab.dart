import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/services/auth.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';

class ProfileTabS extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SimpleUser>(context);
    final studentDoc = Provider.of<DocumentSnapshot>(context);

    FlatButton getInstructorButtonIfExists() {
      if (user.supervisor != "") {
        return FlatButton(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Sign in as ${user.supervisor}  (Teacher)",
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                  ),
                ]),
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/supervisorHome');
            });
      } else {
        return FlatButton(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.person_add,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Become a new Teacher",
                    style: Theme
                        .of(context)
                        .textTheme
                        .button,
                  ),
                ]),
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/userSwitchPage');
            });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile & Settings",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              Navigator.pop(context);

              await _auth.signOut();
            },
            icon: Icon(Icons.exit_to_app),
            label: Text("Logout"),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0),
          Text(
            ' STUDENT NAME',
            style: TextStyle(
              color: Colors.grey,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '${user.teamMember}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 30.0),
          CupertinoButton(
            child: Text(
              "Leave Class",
              style: Theme.of(context).textTheme.button,
            ),
            color: Colors.orange,
            onPressed: () {
              StudentDatabaseService().teamMemberLeavesSection(
                  user.uid, studentDoc.data['instructor']);
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.email,
                color: Colors.grey[400],
              ),
              SizedBox(width: 10.0),
              Text(
                '${user.email}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18.0,
                  letterSpacing: 1.0,
                ),
              )
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[getInstructorButtonIfExists()],
          ),
        ],
      ),
    );
  }
}
