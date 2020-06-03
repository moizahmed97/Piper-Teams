import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/services/auth.dart';

class SupervisorProfilePage extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SimpleUser>(context);

    FlatButton getMemberButtonIfExists() {
      if (user.teamMember != "") {
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
                  Flexible(
                    child: Text(
                      "Sign in as ${user.teamMember} \n (Team Member)",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ]),
            color: Colors.green,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/teamMemberHome');
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
                    "Become a new Team Member",
                    style: Theme.of(context).textTheme.button,
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
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            label: Text("Logout", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0),
          Text(
            ' TEACHER NAME',
            style: TextStyle(
              color: Colors.grey,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '${user.supervisor}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 30.0),
          SizedBox(height: 20.0),
          CupertinoButton(
            child: Text(
              "Useful Tips",
              style: Theme.of(context).textTheme.button,
            ),
            color: Colors.indigoAccent,
            onPressed: () => {},
          ),
          SizedBox(height: 10.0),
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
            children: <Widget>[getMemberButtonIfExists()],
          ),
        ],
      ),
    );
  }
}
