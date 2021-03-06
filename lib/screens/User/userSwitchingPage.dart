import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piper_team_tasks/models/simpleuser.dart';
import 'package:piper_team_tasks/services/auth.dart';
import 'package:piper_team_tasks/services/database.dart';
import 'package:piper_team_tasks/services/teamMemberDatabase.dart';
import 'package:piper_team_tasks/widgets/decoratorForForm.dart';
import 'package:piper_team_tasks/widgets/loading.dart';
import 'package:piper_team_tasks/widgets/hyperlink.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSwitchingPage extends StatefulWidget {
  @override
  _UserSwitchingPageState createState() => _UserSwitchingPageState();
}

class _UserSwitchingPageState extends State<UserSwitchingPage>
    with SingleTickerProviderStateMixin {
  String managerName;
  String managerAge;
  String memberName;
  String memberAge;
  final AuthService _auth = AuthService();

  AnimationController animationController;
  Animation animation, delayedAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    delayedAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
        parent: animationController));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<SimpleUser>(context);
    animationController.forward();

    FlatButton getMemberButton() {
      if (user.teamMember == "") {
        return FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
          color: Colors.lightBlue,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Enter Team Member Details',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    content: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Name", hintText: 'eg. Ahmed'),
                            validator: (val) =>
                                val.isEmpty ? 'Please enter a name' : null,
                            onChanged: (val) =>
                                setState(() => memberName = val),
                          ),
                          Divider(),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Age", hintText: 'eg. 10'),
                            validator: (val) =>
                                val.isEmpty ? 'Please enter an age' : null,
                            onChanged: (val) => setState(() => memberAge = val),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          color: Colors.teal[400],
                          child: Text(
                            'Create',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            TeamMemberDatabaseService()
                                .createMember(user.uid, memberName, memberAge);
                            TeamMemberDatabaseService()
                                .addTeamMemberUserToSimpleUser(
                                    user.uid, memberName);
                            Navigator.of(context)
                                .pushReplacementNamed('/teamMemberHome');
                          }),
                    ],
                  );
                });
          },
        );
      } else {
        return FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                    "Sign in as ${user.teamMember}  (Team Member)",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ]),
          color: Colors.lightBlue,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/teamMemberHome');
          },
        );
      }
    }

    FlatButton getSupervisorButton() {
      if (user.supervisor == "") {
        return FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                  "Become a new Team Manager",
                  style: Theme.of(context).textTheme.button,
                ),
              ]),
          color: Colors.green,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Enter Your Details",
                      style: TextStyle(color: Colors.black),
                    ),
                    content: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Name", hintText: 'eg. Mohammed'),
                            validator: (val) =>
                                val.isEmpty ? 'Please Enter a Name' : null,
                            onChanged: (val) =>
                                setState(() => managerName = val),
                          ),
                          Divider(),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Age", hintText: 'eg. 20'),
                            validator: (val) =>
                                val.isEmpty ? 'Please Provide an Age' : null,
                            onChanged: (val) =>
                                setState(() => managerAge = val),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                          color: Colors.teal[400],
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          }),
                      FlatButton(
                          color: Colors.teal[400],
                          child: Text(
                            'Create',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            DatabaseService().createSupervisor(
                                user.uid, managerName, managerAge);
                            DatabaseService()
                                .addSupervisorNameToUser(user.uid, managerName);
                            Navigator.of(context)
                                .pushReplacementNamed('/supervisorHome');
                          }),
                    ],
                  );
                });
          },
        );
      } else {
        return FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                    "Sign in as ${user.supervisor}  (Supervisor)",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ]),
          color: Colors.green,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/supervisorHome');
          },
        );
      }
    }

    if (user != null) {
      return FadeTransition(
        opacity: animation,
        child: Container(
          child: Scaffold(
            //backgroundColor: Colors.teal[100],
            appBar: AppBar(
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _auth.signOut();
                  },
                  icon: Icon(Icons.exit_to_app, color: Colors.white),
                  label: Text(
                    "Logout",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                )
              ],
              title: Text("Welcome to Piper Teams",
                  style: Theme.of(context).textTheme.headline6),
            ),
            body: FadeTransition(
              opacity: delayedAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Please Select the type of User",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 30),
                  getSupervisorButton(),
                  SizedBox(height: 50.0),
                  getMemberButton(),
                ],
              ),
            ),
            persistentFooterButtons: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    showAboutDialog(
                      applicationLegalese: 'MIT License 2020',
                      useRootNavigator: true,
                      context: context,
                      applicationName: 'Piper teams',
                      applicationVersion: '1.0',
                    );
                  },
                  icon: Icon(Icons.info),
                  label: Text('Licenses ')),
              FlatButton.icon(
                  onPressed: () async {
                    String _url =
                        'https://www.youtube.com/channel/UCp11OSn2mVVGyB6lgWilRFQ';
                    if (await canLaunch(_url)) {
                      await launch(_url);
                    } else {
                      throw 'Could not launch $_url';
                    }
                  },
                  icon: Icon(Icons.info_outline),
                  label: Text('Tips')
                  ,),
              FlatButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Developed using Flutter by",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.teal),
                            ),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Hyperlink('https://github.com/moizahmed97',
                                      'Moiz Ahmed (Github)'),
                                  SizedBox(height: 5),
                                  Text(
                                    "Email : moizahmed97@gmail.com",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("AND"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Hyperlink('https://github.com/fsmonarchy',
                                      'Faisal Abdus Sattar (Github)'),
                                  SizedBox(height: 5),
                                  Text(
                                    "Email : faisalsattar09@gmail.com",
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                ]),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"))
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.code),
                  label: Text('About'))
            ],
          ),
        ),
      );
    } else {
      return Loading();
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
